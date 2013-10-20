class Settlement < ActiveRecord::Base
  # relationship
  belongs_to :store
  has_many :settle_items
  has_many :products, through: :settle_items
end
