class Settlement < ActiveRecord::Base
  # relationship
  belongs_to :store
  has_many :settle_items
  has_many :products, through: :settle_items

  # scopes
  default_scope -> { order('created_at DESC') }
end