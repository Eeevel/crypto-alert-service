# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_10_15_120200) do
  create_table "alerts", force: :cascade do |t|
    t.string "symbol", null: false
    t.decimal "threshold", precision: 15, scale: 8, null: false
    t.integer "direction", default: 1, null: false
    t.boolean "active", default: true, null: false
    t.decimal "last_price", precision: 15, scale: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["symbol"], name: "index_alerts_on_symbol"
  end

  create_table "alerts_notification_channels", id: false, force: :cascade do |t|
    t.integer "alert_id", null: false
    t.integer "notification_channel_id", null: false
    t.index ["alert_id", "notification_channel_id"], name: "index_alerts_channels_unique", unique: true
    t.index ["alert_id"], name: "index_alerts_notification_channels_on_alert_id"
    t.index ["notification_channel_id"], name: "index_alerts_notification_channels_on_notification_channel_id"
  end

  create_table "notification_channels", force: :cascade do |t|
    t.string "name", null: false
    t.integer "kind", default: 0, null: false
    t.json "settings", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "alerts_notification_channels", "alerts"
  add_foreign_key "alerts_notification_channels", "notification_channels"
end
