# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  product_id :integer
#  rating     :integer          default(3)
#  flag       :string(255)      default("approved")
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class Comment < ActiveRecord::Base
  # Allowed ratings
  RATING = (1..5).to_a
  # Flags
  FLAGS = %w(approved spam verify)
  # For each flag
  APPROVED, SPAM, VERIFY = FLAGS

  # Validations
  validates :content, inclusion: { in: RATING }
  validates :flag, inclusion: { in: FLAGS }

  # Relationship
  belongs_to :user
  belongs_to :product
end
