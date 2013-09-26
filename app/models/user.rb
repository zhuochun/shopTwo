class User < ActiveRecord::Base
  # Default roles
  ROLES = %w(customer employee manager administrator)

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :lockable, :recoverable, :rememberable,
         :trackable, :validatable

end
