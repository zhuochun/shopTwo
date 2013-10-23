class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.references :store, index: true
      t.references :product, index: true
      t.integer :quantity
      t.integer :minimum

      t.timestamps
    end
  end
end
