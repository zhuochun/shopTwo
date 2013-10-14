class Product < ActiveRecord::Base
  belongs_to :category, counter_cache: true
  belongs_to :manufacturer, counter_cache: true

  # validations
  validates :name, presence: true
  validates :barcode, presence: true, uniqueness: true

  # scopes
  default_scope -> { order('name ASC') }
  scope :new_in_store, -> { order('created_at DESC') }
  scope :popular, -> { order('current_stock DESC') }

end
