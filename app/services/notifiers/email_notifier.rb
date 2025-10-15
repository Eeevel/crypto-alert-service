module Notifiers
  class EmailNotifier < BaseNotifier
    def notify(alert, current_price)
      to = channel.settings["email"]
      return if to.blank?

      NotificationMailer.with(alert: alert, current_price: current_price, to: to).alert_crossed.deliver_later
    end
  end
end
