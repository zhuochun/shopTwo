class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :barcode, index: true, unique: true
      t.string :name

      t.decimal :daily_price, precision: 9, scale: 2
      t.decimal :cost_price, precision: 9, scale: 2

      t.integer :current_stock
      t.integer :minimum_stock
      t.integer :bundle_unit

      t.references :category, index: true
      t.references :manufacturer, index: true

      t.timestamps
    end
  end
end
