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
  validates :rating, inclusion: { in: RATING }, presence: true
  validates :content, length: { in: 10..500, allow_nil: true, allow_blank: true }
  validates :flag, inclusion: { in: FLAGS }

  # Relationship
  belongs_to :user
  belongs_to :product

  # Scopes
  default_scope -> { order(rating: :desc, created_at: :desc) }
  scope :approved, -> { where(flag: APPROVED) }
  scope :spam, -> { where(flag: SPAM) }
  scope :verify, -> { where(flag: VERIFY) }

  # Mark this comment spam (lazy delete)
  def mark_spam
    self.update(flag: SPAM)
  end

end
