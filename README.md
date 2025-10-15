# Crypto Alert Service

A simple single-user crypto alert service built with Ruby on Rails. It lets you:

- Create alerts: pick a symbol (e.g. BTCUSDT), a threshold price, and direction (up/down)
- Configure notification channels: log, email, browser
- Get notified when price crosses your threshold using Binance HTTP API.

## Requirements

- Ruby 3.3+
- Bundler
- Node + Yarn
- SQlite

## Setup

```bash
bundle install
yarn install
bin/rails db:setup
bin/rails db:migrate
```

## Run

```bash
bin/dev
```

- Open http://localhost:3000
- Create a notification channel first (e.g. Log, Email with {"email": "you@example.com"}, or Browser)
- Create one or more alerts and select channels to notify
- Keep the page open to receive browser notifications (allow notifications when prompted)

## Notes

- Price polling runs every ~30 seconds using a simple in-process scheduler that enqueues `CheckPricesJob`.
- Add new notification channels by creating a notifier under `app/services/notifiers/` and mapping it in `CheckPricesJob#notifier_for`.
- Email delivery uses `letter_opener` in development to preview in browser.
- This app is single-user by design. No authentication.

## Binance API

Uses `https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT` style endpoints per alert.
