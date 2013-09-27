class AddProductsCountToManufacturer < ActiveRecord::Migration
  def change
    add_column :manufacturers, :products_count, :integer
  end
end
