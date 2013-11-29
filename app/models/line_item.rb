# == Schema Information
#
# Table name: line_items
#
#  id            :integer          not null, primary key
#  product_id    :integer
#  cart_id       :integer
#  order_id      :integer
#  quantity      :integer          default(1)
#  price         :decimal(9, 2)    default(0.0)
#  created_at    :datetime
#  updated_at    :datetime
#  discount_rate :decimal(3, 2)
#

class LineItem < ActiveRecord::Base
  # relationships
  belongs_to :product
  belongs_to :cart
  belongs_to :order

  # delegate
  delegate :name, :barcode, :image_path, :daily_price, :bundle_unit, to: :product

  # get discount rate
  def discount
    @discount = discount_rate ||
      if bundle_unit > 0 && quantity >= bundle_unit
        0.1
      else
        0.0
      end
  end

  # get discount value
  def discount_value
    sell_price * discount
  end

  # get price after discount
  def discount_price
    sell_price * (1 - discount)
  end

  # get price at selling
  def sell_price
    @sell_price = price || product.daily_price
  end

  # get subtotal
  def subtotal
    discount_price * quantity
  end

  # get subtotal without discount
  def subtotal_without_discount
    sell_price * quantity
  end

  # get subtotal of discount value
  def discount_subtotal
    discount_value * quantity
  end
end
