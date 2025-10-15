module Notifiers
  class BrowserNotifier < BaseNotifier
    def notify(alert, current_price)
      ActionCable.server.broadcast(
        "price_notifications",
        {
          title: "Crypto Alert",
          body: "#{alert.symbol} crossed #{alert.threshold} going #{alert.direction} (#{current_price})"
        }
      )
    end
  end
end
