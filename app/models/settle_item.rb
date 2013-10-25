class SettleItem < ActiveRecord::Base
  # relationships
  belongs_to :settlement
  belongs_to :product, foreign_key: 'barcode'

  # delegate
  delegate :name, :daily_price, :bundle_unit, :barcode, to: :product

  # validates
  validates :quantity, :price, :total_price, numericality: { greater_than_or_equal_to: 0 }

  # scopes
  default_scope -> { order('created_at DESC') }
  scope :last_week, -> { where('created_at >= ?', self.get_from_time(1.week)) }
  scope :last_month, -> { where('created_at >= ?', self.get_from_time(1.month)) }

  # hooks
  before_create :deduct_stocks_from_store

  # make sure stocks are reduced
  def deduct_stocks_from_store
    Stock.where(product_id: barcode, store_id: store_id).take.deduct_stocks(quantity)
  end

  # get time
  def self.get_from_time(period)
    if ENV['CUSTOM_CURRENT_DATE']
      DateTime.parse(ENV['CURRENT_DATE']) - period
    else
      period.ago.midnight
    end
  end

end
