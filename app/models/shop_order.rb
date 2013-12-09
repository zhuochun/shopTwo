# == Schema Information
#
# Table name: shop_orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  store_id   :integer
#  quantity   :integer
#  subtotal   :decimal(, )
#  credits    :decimal(, )
#  created_at :datetime
#  updated_at :datetime
#

class ShopOrder < ActiveRecord::Base
  belongs_to :user
  belongs_to :store
end
