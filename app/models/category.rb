# == Schema Information
#
# Table name: categories
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  products_count :integer
#

class Category < ActiveRecord::Base
  has_many :products

  # validations
  validates :name, presence: true
end
