class CreateSettleItems < ActiveRecord::Migration
  def change
    create_table :settle_items do |t|
      t.references :settlement, index: true
      t.references :product, index: true
      t.integer :quantity
      t.decimal :price, precision: 9, scale: 2

      t.timestamps
    end
  end
end
