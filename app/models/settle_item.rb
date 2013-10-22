class SettleItem < ActiveRecord::Base
  belongs_to :settlement
  belongs_to :product, foreign_key: 'barcode'
end
