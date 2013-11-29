class AddPayTypeToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :pay_type, :string, default: "Cash"
    add_column :orders, :price, :decimal
    add_column :orders, :discount, :decimal
    add_column :orders, :size, :integer
  end
end
