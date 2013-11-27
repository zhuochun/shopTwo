# == Schema Information
#
# Table name: carts
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class Cart < ActiveRecord::Base
  # relationships
  has_many :line_items, dependent: :destroy

  # scope
  default_scope -> { includes(:line_items) }

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

  # get total quantity
  def quantity
    line_items.inject(0) { |sum, item| sum + item.quantity } || 0
  end

  # is empty cart
  def empty?
    quantity < 1
  end

  # get subtotal
  def subtotal
    line_items.to_a.sum { |item| item.subtotal }
  end

  # get sub total without discount
  def subtotal_without_discount
    line_items.to_a.sum { |item| item.subtotal_without_discount }
  end

  # get discount value subtotal
  def discount_subtotal
    line_items.to_a.sum { |item| item.discount_value }
  end
end
