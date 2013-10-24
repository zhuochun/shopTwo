class AddStoreIdToSettleItems < ActiveRecord::Migration
  def change
    add_column :settle_items, :store_id, :integer
    add_index :settle_items, :store_id
  end
end
