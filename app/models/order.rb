class Order < ActiveRecord::Base
  # relationships
  belongs_to :user
  has_many   :line_items, dependent: :destroy
end
