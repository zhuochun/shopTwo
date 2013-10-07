class Store < ActiveRecord::Base
  def location
    [geo_latitude, geo_longitude]
  end
end
