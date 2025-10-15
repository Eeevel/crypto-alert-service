class CreateNotificationChannels < ActiveRecord::Migration[7.1]
  def change
    create_table :notification_channels do |t|
      t.string :name, null: false
      t.integer :kind, null: false, default: 0
      t.json :settings, null: false, default: {}

      t.timestamps
    end
  end
end
