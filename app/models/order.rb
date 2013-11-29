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
#

class Order < ActiveRecord::Base
  # payment method
  PAYMENT_TYPES = ["Credit Card", "Cash"]

  # validations
  validates :name, :email, :phone, :address, presence: true
  validates :pay_type, inclusion: { in: PAYMENT_TYPES }

  # relationships
  belongs_to :user
  has_many   :line_items, dependent: :destroy
end
