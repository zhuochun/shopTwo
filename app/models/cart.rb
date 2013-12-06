# == Schema Information
#
# Table name: carts
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

class Cart < ActiveRecord::Base
  # relationships
  belongs_to :user
  has_many :line_items, dependent: :destroy

  # scope
  default_scope -> { includes(:line_items) }

  # properties
  include Payable

  # add a line item
  def add_item(params)
    item = line_items.where(product_id: params[:product_id]).take

    if item
      item.quantity += params[:quantity].to_i
    else
      item = line_items.new(params)
    end

    item
  end

  # merge line items from another cart
  def merge_items(cart)
    cart.line_items.each do |i|
      item = line_items.where(product_id: i.product_id).take

      if item
        item.quantity += i.quantity
        item.save
      else
        i.update(cart: self)
      end
    end
  end
end
