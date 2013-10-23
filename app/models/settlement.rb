class Settlement < ActiveRecord::Base
  # relationship
  belongs_to :store
  has_many :settle_items
  has_many :products, through: :settle_items

  # scopes
  default_scope -> { order('created_at DESC') }
  scope :last_week, -> { where('created_at >= ?', 1.week.ago.midnight) }
  scope :last_month, -> { where('created_at >= ?', 1.week.ago.midnight) }
  scope :sell_sum, -> { sum('total_count') }

end
