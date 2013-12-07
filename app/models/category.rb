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
  # relations
  has_many :products

  # validations
  validates :name, presence: true, length: { in: 3..200 }

  # take any num products
  def random_products(num)
    if products_count > num
      products.offset(Random.rand(products_count - num)).take(num)
    elsif products_count > 1
      products.take(num)
    else
      Product.none
    end
  end
end
