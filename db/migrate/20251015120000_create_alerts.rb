class CreateAlerts < ActiveRecord::Migration[7.1]
  def change
    create_table :alerts do |t|
      t.string :symbol, null: false
      t.decimal :threshold, precision: 15, scale: 8, null: false
      t.integer :direction, null: false, default: 1
      t.boolean :active, null: false, default: true
      t.decimal :last_price, precision: 15, scale: 8

      t.timestamps
    end

    add_index :alerts, :symbol
  end
end
