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
  belongs_to :product
  belongs_to :cart
  belongs_to :order
end
