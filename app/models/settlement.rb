class Settlement < ActiveRecord::Base
  # relationship
  belongs_to :store
  has_many :settle_items, dependent: :destroy
  has_many :products, through: :settle_items

  # validates
  validate :total_price, :total_count, numericality: { greater_than_or_equal_to: 0 }

  # scopes
  default_scope -> { order('created_at DESC') }
  scope :last_week, -> { where('created_at >= ?', self.get_from_time(1.week)) }
  scope :last_month, -> { where('created_at >= ?', self.get_from_time(1.month)) }

  # get time
  def self.get_from_time(period)
    if ENV['CUSTOM_CURRENT_DATE']
      DateTime.parse(ENV['CURRENT_DATE']) - period
    else
      period.ago.midnight
    end
  end

end
