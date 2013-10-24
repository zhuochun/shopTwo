class SettleItem < ActiveRecord::Base
  # relationships
  belongs_to :settlement
  belongs_to :product, foreign_key: 'barcode'

  # validates
  validates :quantity, :price, :total_price, numericality: { greater_than_or_equal_to: 0 }

  # scopes
  default_scope -> { order('created_at DESC') }
  scope :last_week, -> { where('created_at >= ?', 1.week.ago.midnight) }
  scope :last_month, -> { where('created_at >= ?', 1.month.ago.midnight) }

  # hooks
  before_create :deduct_stocks_from_store

  private

  # make sure stocks are reduced
  def deduct_stocks_from_store
    Stock.find(product_id: barcode, store_id: store_id).deduct_stocks(quantity)
  end

end
