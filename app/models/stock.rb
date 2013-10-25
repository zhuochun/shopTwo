class Stock < ActiveRecord::Base
  # relationships
  belongs_to :store
  belongs_to :product

  # validations
  validates :store_id, :product_id, :quantity, :minimum, presence: true
  validates :quantity, :minimum, numericality: { greater_than_or_equal_to: 0 }

  # scope
  default_scope -> { includes(:product).order('quantity DESC') }

  # deduct apply to self and hq stock as well
  def deduct_stocks(amount)
    return false if amount > quantity

    Stock.transaction do
      self.quantity -= amount
      self.product.current_stock -= amount
      self.product.save
      self.save
    end
  end

  # delegate
  delegate :name, :daily_price, :bundle_unit, :barcode, to: :product
end
