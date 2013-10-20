class Store < ActiveRecord::Base
  # Relationship
  has_many :users

  def location
    [geo_latitude, geo_longitude]
  end
end
