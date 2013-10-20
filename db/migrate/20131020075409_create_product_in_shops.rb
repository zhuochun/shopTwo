class CreateProductInShops < ActiveRecord::Migration
  def change
    create_table :product_in_shops do |t|
      t.references :store, index: true
      t.references :product, index: true
      t.integer :quantity

      t.timestamps
    end
  end
end
