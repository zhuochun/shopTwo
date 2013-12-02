module ApplicationHelper

  def shop_title
    return 'ShopTwo' unless user_signed_in?

    if current_user.customer?
      "ShopTwo"
    elsif current_user.store
      "ShopTwo:#{current_user.store.name}"
    else
      'ShopTwo:Admin'
    end
  end

  def alert_box(message, type)
    content_tag :div, class: "alert alert-dismissable alert-#{type}" do
      "<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button>#{message}".html_safe
    end
  end

  def button(name)
    content_tag :i, "", class: "glyphicon glyphicon-#{name}"
  end

  def timezone_date(datetime)
    datetime.in_time_zone.strftime("%B %d, %Y") 
  end

  def administrative_view?
    user_signed_in? && current_user.management?
  end

  def customer_view?
    !administrative_view?
  end

end
