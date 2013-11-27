class AddDiscountRateToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :discount_rate, :decimal, precision: 3, scale: 2
  end
end
