class PriceNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "price_notifications"
  end
end
