class Store < ActiveRecord::Base
  # Relationship
  has_many :users
  has_many :product_in_shops
  has_many :products, through: :product_in_shops

  def location
    [geo_latitude, geo_longitude]
  end
end
