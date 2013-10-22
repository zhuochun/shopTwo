class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.integer :size
      t.text :address
      t.float :geo_latitude
      t.float :geo_longitude
      t.integer :contact
      t.text :operation_hours

      t.timestamps
    end

    add_index :stores, :contact
  end
end
