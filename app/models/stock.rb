class Stock < ActiveRecord::Base
  # relationships
  belongs_to :store
  belongs_to :product

  # validations
  validates :store, :product, :quantity, :minimum, presence: true
  validates :quantity, :minimum, numericality: { greater_than_or_equal_to: 0 }

  # scope
  default_scope -> { includes(:product).order('products.name ASC') }
end
