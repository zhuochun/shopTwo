class SettleItem < ActiveRecord::Base
  # relationships
  belongs_to :settlement
  belongs_to :product, foreign_key: 'barcode'

  # validates
  validates :quantity, :price, :total_price, numericality: { greater_than_or_equal_to: 0 }

  # hooks
  before_create :deduct_stock_from_store
  def deduct_stock_from_store
    # TODO
  end

end
