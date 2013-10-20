class User < ActiveRecord::Base
  # Default roles
  ROLES = %w(customer employee manager administrator)
  # For each role
  CUSTOMER, EMPLOYEE, MANAGER, ADMIN = ROLES

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :lockable, :recoverable, :rememberable,
         :trackable, :validatable

  # Validations
  validates :username, presence: true, uniqueness: true
  validates :credits, presence: true
  validates :phone, uniqueness: true

  # Scopes
  default_scope -> { order("username ASC") }
  scope :customers, -> { where(role: CUSTOMER) }
  scope :employees, -> { where(role: [EMPLOYEE, MANAGER]) }
  scope :managers,  -> { where(role: [MANAGER, ADMIN]) }

  # Public: is this a management role
  def management?
    role == MANAGER || role == ADMIN
  end
end
