class CreateSettleItems < ActiveRecord::Migration
  def change
    create_table :settle_items do |t|
      t.references :settlement, index: true
      t.integer :barcode
      t.integer :quantity, default: 0
      t.decimal :price, precision: 9, scale: 2, default: 0
      t.decimal :total_price, precision: 9, scale: 2, default: 0

      t.timestamps
    end

    add_index :settle_items, :barcode
  end
end
