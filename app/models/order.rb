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
#

class Order < ActiveRecord::Base
  # relationships
  belongs_to :user
  has_many   :line_items, dependent: :destroy
end
