class CreateAlertsNotificationChannelsJoin < ActiveRecord::Migration[7.1]
  def change
    create_table :alerts_notification_channels, id: false do |t|
      t.belongs_to :alert, null: false, foreign_key: true
      t.belongs_to :notification_channel, null: false, foreign_key: true
    end

    add_index :alerts_notification_channels, [:alert_id, :notification_channel_id], unique: true, name: "index_alerts_channels_unique"
  end
end
