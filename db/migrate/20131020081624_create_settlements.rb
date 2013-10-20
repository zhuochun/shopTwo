class CreateSettlements < ActiveRecord::Migration
  def change
    create_table :settlements do |t|
      t.references :store, index: true
      t.decimal :total_price, precision: 9, scale: 2
      t.string :uuid

      t.timestamps
    end
  end
end
