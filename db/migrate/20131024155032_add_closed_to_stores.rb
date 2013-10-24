class AddClosedToStores < ActiveRecord::Migration
  def change
    add_column :stores, :closed, :Boolean
  end
end
