class Product < ActiveRecord::Base
  belongs_to :category, counter_cache: true
  belongs_to :manufacturer, counter_cache: true

  # validations
  validates :name, presence: true
  validates :barcode, presence: true, uniqueness: true

end
