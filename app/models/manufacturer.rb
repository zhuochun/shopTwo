class Manufacturer < ActiveRecord::Base
  has_many :products

  # validations
  validates :name, presence: true
end
