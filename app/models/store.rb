class Store < ActiveRecord::Base
  # relationship
  has_many :users
  has_many :settlements
  has_many :stocks
  has_many :products, through: :stocks

  # valiations
  validates :name, presence: true

  # scope
  default_scope -> { order(:size) }

  def location
    [geo_latitude, geo_longitude]
  end

  # reopen a store
  def reopen
    self.closed = false
    self.save
  end

  # close down a store
  def close_down
    self.closed = true
    self.stocks.destroy_all
    self.save
  end
end
