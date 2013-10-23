module ApplicationHelper

  def shop_title
    return 'ShopTwo' unless current_user

    if current_user.customer?
      "ShopTwo"
    elsif current_user.store
      "ShopTwo:#{current_user.store.name}"
    else
      'ShopTwo:Admin'
    end
  end

end
