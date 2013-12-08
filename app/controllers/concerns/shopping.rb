module Shopping

  # Get current cart or create a new cart
  def current_cart
    @current_cart ||= find_or_merge_user_cart(Cart.find(session[:cart_id]))
  rescue ActiveRecord::RecordNotFound
    @current_cart = create_or_get_user_cart
    session[:cart_id] = @current_cart.id
  end

  protected

  # Get user cart or current cart
  def find_or_merge_user_cart(cart)
    return cart unless user_signed_in?
    return cart if current_user.cart == cart

    if current_user.cart.nil?
      cart.update(user: current_user)
      cart
    else
      current_user.cart.merge_items(cart)
      session[:cart_id] = current_user.cart.id
      current_user.cart
    end
  end

  # Create or get current user's cart
  def create_or_get_user_cart
    return Cart.create unless user_signed_in?

    if current_user.cart.nil?
      Cart.create(user: current_user)
    else
      current_user.cart
    end
  end

end
