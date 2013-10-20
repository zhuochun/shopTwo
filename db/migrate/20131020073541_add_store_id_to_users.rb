class AddStoreIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :store_id, :integer
    add_index :users, :store_id
  end
end
