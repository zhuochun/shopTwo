class Cart < ActiveRecord::Base
  # relationships
  has_many :line_items, dependent: :destroy

  # scope
  default_scope -> { includes(:line_items) }

  # get total quantity
  def quantity
    line_items.inject { |sum, item| sum + item.quantity }
  end
end
