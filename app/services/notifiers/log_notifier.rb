module Notifiers
  class LogNotifier < BaseNotifier
    def notify(alert, current_price)
      Rails.logger.info(
        "[ALERT] #{alert.symbol} crossed #{alert.threshold} going #{alert.direction} (price=#{current_price})"
      )
    end
  end
end
