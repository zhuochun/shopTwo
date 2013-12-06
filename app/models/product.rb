# == Schema Information
#
# Table name: products
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  daily_price     :decimal(9, 2)
#  cost_price      :decimal(9, 2)
#  current_stock   :integer
#  minimum_stock   :integer
#  bundle_unit     :integer
#  category_id     :integer
#  manufacturer_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Product < ActiveRecord::Base
  # alias
  alias_attribute :barcode, :id

  # relationship
  belongs_to :category, counter_cache: true
  belongs_to :manufacturer, counter_cache: true

  has_many :stocks
  has_many :stores, through: :stocks

  has_many :settle_items, foreign_key: 'barcode'
  has_many :settlements, through: :settle_items

  has_many :line_items
  has_many :orders, through: :line_items

  has_many :comments

  # validations
  validates :name, :barcode, :cost_price, :current_stock, :minimum_stock, presence: true
  validates :category, :manufacturer, presence: true
  validates :current_stock, :minimum_stock, :bundle_unit, numericality: { greater_than_or_equal_to: 0 }
  validates :daily_price, :cost_price, numericality: { greater_than_or_equal_to: 0 }
  validates :barcode, format: { with: /\A\d{8}\z/, message: "invalid barcode" }
  # custom validate
  validate  :current_stock_larger_than_available_stock
  # update and check quantity
  def current_stock_larger_than_available_stock
    if available_stock < 0
      errors.add(:current_stock, "is less than available stock")
    end
  end

  # hooks
  before_validation -> { self.daily_price = cost_price * 1.3 if cost_price && !daily_price }

  # scopes
  default_scope -> { order(:name).includes(:manufacturer, :category) }
  scope :new_in_store, -> { order(created_at: :desc) }
  scope :popular, -> (num) do
    Product.find(
      SettleItem.unscoped
                .select(:barcode)
                .group(:barcode)
                .sum(:quantity)
                .take(num)
                .map { |r| r.first }
    )
  end

  # properties
  include ActivePricing
  include Stockable

  # image
  def image_path
    "products/#{barcode % 43}.jpg"
  end

  # related products
  def related_products
    category.random_products(6)
  end

  # dynamic pricing
  def self.active_pricing
    Product.transaction do
      self.find_each(batch_size: 500) do |product|
        product.update_price
      end
    end
  end
end
