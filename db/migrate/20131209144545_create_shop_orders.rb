class CreateShopOrders < ActiveRecord::Migration
  def change
    create_table :shop_orders do |t|
      t.references :user, index: true
      t.references :store, index: true
      t.integer :quantity
      t.decimal :subtotal
      t.decimal :credits

      t.timestamps
    end
  end
end
