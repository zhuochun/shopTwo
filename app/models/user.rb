class User < ActiveRecord::Base
  # Default roles
  ROLES = %w(customer employee manager administrater)
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
  validates :phone, presence: true, uniqueness: true

  # Scopes
  default_scope -> { order("username ASC") }
  scope :customers, -> { where(role: CUSTOMER) }
  scope :employees, -> { where(role: [EMPLOYEE, MANAGER]) }
  scope :managers,  -> { where(role: [MANAGER, ADMIN]) }

  # Relationship
  belongs_to :store

  # Public: is the user manage the store
  def manage?(store)
    role == MANAGER && self.store == store
  end

  # Public: is this a management role
  def management?
    if role == MANAGER || role == ADMIN
      true
    else
      false
    end
  end

  # Public: role? methods
  ROLES.each do |role|
    define_method "#{role}?" do
      self.role == role
    end
  end

end
