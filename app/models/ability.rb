class Ability
  include CanCan::Ability

  # The first argument to `can` is the action you are giving the user 
  # permission to do.
  # If you pass :manage it will apply to every action. Other common actions
  # here are :read, :create, :update and :destroy.
  #
  # The second argument is the resource the user can perform the action on.
  # If you pass :all it will apply to every resource. Otherwise pass a Ruby
  # class of the resource.
  #
  # The third argument is an optional hash of conditions to further filter the
  # objects.
  # For example, here the user can only update published articles.
  #
  #   can :update, Article, :published => true
  #
  # See the wiki for details:
  # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.role == User::ADMIN
      can :manage, Product
      can :manage, Category
      can :manage, Manufacturer
      can :read, :all
    elsif user.role == User::MANAGER
      can :manage, Stock
      can :read, :all
    elsif user.role == User::EMPLOYEE
      can :read, Stock
      basic_ability
    elsif user.role == User::CUSTOMER
      basic_ability
    else
      basic_ability
    end
  end

  def basic_ability
    can :read, Product
    can :read, Category
    can :read, Manufacturer
  end
end
