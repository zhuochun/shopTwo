class User < ActiveRecord::Base
  # Default roles
  ROLES = %w(customer employee manager administrator)

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :lockable, :recoverable, :rememberable,
         :trackable, :validatable

  # Validations
  validates :username, presence: true, uniqueness: true
  validates :credits, presence: true
  validates :phone, uniqueness: true
end
