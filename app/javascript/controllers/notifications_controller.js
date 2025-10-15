import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  connect() {
    if (!("Notification" in window)) return
    if (Notification.permission === "default") Notification.requestPermission()

    this.subscription = consumer.subscriptions.create({ channel: "PriceNotificationsChannel" }, {
      received: (data) => {
        if (Notification.permission === "granted") {
          new Notification(data.title, { body: data.body })
        }
      }
    })
  }

  disconnect() {
    if (this.subscription) this.subscription.unsubscribe()
  }
}
