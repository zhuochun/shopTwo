class Stock < ActiveRecord::Base
  # relationships
  belongs_to :store
  belongs_to :product

  # validations
  validates :store, :product, :quantity, :minimum, presence: true

  # scope
  default_scope -> { includes(:product).order('products.name ASC') }
end
