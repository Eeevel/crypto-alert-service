require 'net/http'
require 'json'
require 'bigdecimal'

class CheckPricesJob < ApplicationJob
  queue_as :default

  BINANCE_URL = "https://api.binance.com/api/v3/ticker/price?symbol="

  def perform
    Alert.active.find_each do |alert|
      current_price = fetch_price(alert.symbol)
      next if current_price.nil?

      if alert.crossed?(current_price)
        notify_all(alert, current_price)
      end

      alert.update_column(:last_price, current_price)
    end
  end

  private

  def fetch_price(symbol)
    sym = symbol.to_s.strip.upcase
    url = URI.parse(BINANCE_URL + sym)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https')
    http.open_timeout = 5
    http.read_timeout = 5

    request = Net::HTTP::Get.new(url)
    request['User-Agent'] = 'crypto-alert-service/1.0'

    response = http.request(request)
    unless response.is_a?(Net::HTTPSuccess)
      Rails.logger.warn("Binance HTTP #{response.code} for #{sym}: #{response.body}")
      return nil
    end

    body = JSON.parse(response.body)
    price_string = body["price"]
    return nil if price_string.nil?

    BigDecimal(price_string)
  rescue StandardError => e
    Rails.logger.error("fetch_price error for #{symbol}: #{e.class} #{e.message}")
    nil
  end

  def notify_all(alert, current_price)
    alert.notification_channels.find_each do |ch|
      notifier_for(ch).notify(alert, current_price)
    end
  end

  def notifier_for(channel)
    case channel.kind.to_sym
    when :log
      Notifiers::LogNotifier.new(channel)
    when :email
      Notifiers::EmailNotifier.new(channel)
    when :browser
      Notifiers::BrowserNotifier.new(channel)
    else
      Notifiers::LogNotifier.new(channel)
    end
  end
end
