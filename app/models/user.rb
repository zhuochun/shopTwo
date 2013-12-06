# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string(255)      default(""), not null
#  phone                  :string(255)
#  birthday               :date
#  credits                :decimal(15, 2)   default(0.1), not null
#  role                   :string(255)      default("customer"), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  failed_attempts        :integer          default(1), not null
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  store_id               :integer
#  location               :text
#

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
  validates :role, inclusion: { in: ROLES }

  # Scopes
  default_scope -> { order("username ASC") }
  scope :customers, -> { where(role: CUSTOMER) }
  scope :employees, -> { where(role: [EMPLOYEE, MANAGER]) }
  scope :managers,  -> { where(role: [MANAGER, ADMIN]) }

  # Relationship
  # managers/employees
  belongs_to :store
  # customers
  has_one    :cart
  has_many   :orders
  has_many   :comments

  # is the user manage the store
  def manage?(store)
    role == MANAGER && self.store == store
  end

  # is this a management role
  def management?
    role == MANAGER || role == ADMIN
  end

  # is role? methods
  ROLES.each do |role|
    define_method "#{role}?" do
      self.role == role
    end
  end

end
