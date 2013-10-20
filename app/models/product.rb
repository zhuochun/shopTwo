class Product < ActiveRecord::Base
  # relationship
  belongs_to :category, counter_cache: true
  belongs_to :manufacturer, counter_cache: true
  has_many :product_in_shops
  has_many :stores, through: :product_in_shops

  # validations
  validates :name, presence: true
  validates :barcode, presence: true, uniqueness: true

  # scopes
  default_scope -> { order('name ASC') }
  scope :new_in_store, -> { order('created_at DESC') }
  scope :popular, -> { order('current_stock DESC') }

end
