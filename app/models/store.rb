class Store < ActiveRecord::Base
  # relationship
  has_many :users
  has_many :settlements
  has_many :stocks
  has_many :products, through: :stocks

  # scope
  default_scope -> { order('name ASC') }

  def location
    [geo_latitude, geo_longitude]
  end
end
