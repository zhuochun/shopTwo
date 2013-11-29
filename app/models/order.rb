# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string(255)
#  email      :string(255)
#  phone      :string(255)
#  address    :text
#  created_at :datetime
#  updated_at :datetime
#  pay_type   :string(255)      default("Cash")
#  price      :decimal(, )
#  discount   :decimal(, )
#  size       :integer
#

class Order < ActiveRecord::Base
  # payment method
  PAYMENT_TYPES = ["Credit Card", "Cash"]

  # validations
  validates :name, :email, :phone, :address, :pay_type, presence: true
  validates :pay_type, inclusion: { in: PAYMENT_TYPES }

  # relationships
  belongs_to :user
  has_many   :line_items, dependent: :destroy

  # hooks
  before_create :remove_items_from_cart
  before_create :save_local_data_to_order_and_items
  after_create  :update_user_credits
  # remove items from cart
  def remove_items_from_cart
    line_items.each { |i| i.cart = nil }
  end
  # save the data at point of purchase
  def save_local_data_to_order_and_items
    self.price    = subtotal
    self.discount = discount_subtotal
    self.size     = quantity

    line_items.each do |i|
      i.price = i.sell_price
      i.discount_rate = i.discount
    end
  end
  # update user credits, clean up cart
  def update_user_credits
    user.credits += credits
    user.save
  end

  # properties
  include Payable

  # add user information
  def add_user_info(user)
    self.name    ||= user.username
    self.email   ||= user.email
    self.phone   ||= user.phone
    self.address ||= user.location
  end

  # add carts line items
  def add_items_from_cart(cart)
    cart.line_items.each do |item|
      self.line_items << item if item.sufficient_stock?
    end
  end
end
