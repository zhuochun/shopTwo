class CreateSettlements < ActiveRecord::Migration
  def change
    create_table :settlements do |t|
      t.references :store, index: true
      t.integer :total_count, default: 0
      t.decimal :total_price, precision: 9, scale: 2, default: 0

      t.timestamps
    end
  end
end
