class Stock < ActiveRecord::Base
  # relationships
  belongs_to :store
  belongs_to :product

  # scope
  default_scope -> { includes(:product).order('product.name ASC') }
end
