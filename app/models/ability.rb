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
    @user = user || User.new # guest user (not logged in)

    if @user.administrater?
      can :manage, Product
      can :manage, Category
      can :manage, Manufacturer
      can :manage, Store
      can :manage, User

      can :read, :all
      can :view, :all

      online_shop_power_ability
    elsif @user.manager?
      can :manage, Stock
      can :manage, Settlement
      can :manage, SettleItem
      can :manage, Store, id: @user.store_id

      can :read, :all
      can :view, :all

      online_shop_power_ability
    elsif @user.employee?
      can :read, Stock
      can :read, Settlement
      can :read, SettleItem
      can :read, User, role: User::CUSTOMER

      basic_ability
      online_shop_ability
    elsif @user.customer?
      basic_ability
      online_shop_ability
    else
      basic_ability
      online_shop_ability
    end
  end

  def basic_ability
    can :read, Product
    can :read, Category
    can :read, Manufacturer
  end

  def online_shop_ability
    can [:read, :create, :edit, :destroy], Cart
    can [:read, :create, :edit, :destroy], Order, user_id: @user.id
    can [:read, :create, :edit, :destroy], LineItem
  end

  def online_shop_power_ability
    can :manage, Cart
    can :manage, Order, user_id: @user.id
    can :manage, LineItem
  end
end
