# == Schema Information
#
# Table name: stores
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  size            :integer
#  address         :text
#  geo_latitude    :float
#  geo_longitude   :float
#  contact         :integer
#  operation_hours :text
#  created_at      :datetime
#  updated_at      :datetime
#  closed          :boolean
#

class Store < ActiveRecord::Base
  # relationship
  has_many :users
  has_many :settlements
  has_many :stocks
  has_many :products, through: :stocks

  # valiations
  validates :name, presence: true
  validates :size, numericality: { greater_than_or_equal_to: 0 }
  validates :contact, format: { with: /\A\d{8}\z/, message: "invalid contact number" }
  validates :geo_latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :geo_longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

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
