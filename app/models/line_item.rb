# == Schema Information
#
# Table name: line_items
#
#  id         :integer          not null, primary key
#  product_id :integer
#  cart_id    :integer
#  order_id   :integer
#  quantity   :integer          default(1)
#  price      :decimal(9, 2)    default(0.0)
#  created_at :datetime
#  updated_at :datetime
#

class LineItem < ActiveRecord::Base
  # relationships
  belongs_to :product
  belongs_to :cart
  belongs_to :order

  # delegate
  delegate :name, :barcode, :image_path, :daily_price, :bundle_unit, to: :product

  # get price at selling
  def sell_price
    if price < 0.01
      product.daily_price
    else
      price
    end
  end

  # get discount
  def discount
    discount_rate ||
      if bundle_unit > 0 && quantity > bundle_unit
        0.1
      else
        0.0
      end
  end

  # get discount value
  def discount_value
    sell_price * discount
  end

  # get actual price
  def actual_price
    sell_price * (1 - discount)
  end

  # get sub total
  def subtotal
    actual_price * quantity
  end

  # get sub total without discount
  def subtotal_without_discount
    sell_price * quantity
  end

end
