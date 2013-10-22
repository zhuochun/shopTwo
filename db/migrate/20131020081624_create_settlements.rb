class CreateSettlements < ActiveRecord::Migration
  def change
    create_table :settlements do |t|
      t.references :store, index: true
      t.string :uuid
      t.decimal :total_price, precision: 9, scale: 2

      t.timestamps
    end

    add_index :settlements, :uuid
  end
end
