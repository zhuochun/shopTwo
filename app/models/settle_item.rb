class SettleItem < ActiveRecord::Base
  # relationships
  belongs_to :settlement
  belongs_to :product, foreign_key: 'barcode'

  # hooks
  before_create :deduct_stock_from_store
  def deduct_stock_from_store
    # TODO
  end

end
