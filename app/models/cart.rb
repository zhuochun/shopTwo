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
end
