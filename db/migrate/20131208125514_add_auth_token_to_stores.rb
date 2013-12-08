class AddAuthTokenToStores < ActiveRecord::Migration
  def change
    add_column :stores, :auth_token, :string
  end
end
