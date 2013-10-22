class Product < ActiveRecord::Base
  # alias
  alias_attribute :barcode, :id

  # relationship
  belongs_to :category, counter_cache: true
  belongs_to :manufacturer, counter_cache: true

  has_many :product_in_shops
  has_many :stores, through: :product_in_shops

  has_many :settle_items, foreign_key: 'barcode'
  has_many :settlements, through: :settle_items

  # validations
  validates :name, :barcode, :cost_price,
            :current_stock, :minimum_stock, presence: true

  # hooks
  before_create -> { self.daily_price = cost_price * 1.3 unless daily_price }

  # scopes
  default_scope -> { order('name ASC') }
  scope :new_in_store, -> { order('created_at DESC') }
  scope :popular, -> { order('current_stock DESC') }

  # adjust price
  def adjust_price
  end

  # dynamic pricing
  def self.dynamic_pricing
  end
end
