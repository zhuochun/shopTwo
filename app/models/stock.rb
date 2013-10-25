class Stock < ActiveRecord::Base
  # relationships
  belongs_to :store
  belongs_to :product

  # delegate
  delegate :name, :daily_price, :new_daily_price, :available_stock,
           :bundle_unit, :barcode, to: :product

  # validations
  validates :store_id, :product_id, :quantity, :minimum, presence: true
  validates :quantity, :minimum, numericality: { greater_than_or_equal_to: 0 }
  # custom validate
  validate  :quantity_is_less_than_available_stock

  # scope
  default_scope -> { order('quantity DESC') }

  # update and check quantity
  def quantity_is_less_than_available_stock
    if quantity > available_stock
      errors.add(:quantity, "exceeded the available stock")
    end
  end

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
end
