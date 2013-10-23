class Store < ActiveRecord::Base
  # relationship
  has_many :users
  has_many :settlements
  has_many :product_in_shops
  has_many :products, through: :product_in_shops

  # scope
  default_scope -> { order('name ASC') }

  def location
    [geo_latitude, geo_longitude]
  end
end
