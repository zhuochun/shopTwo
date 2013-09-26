module ApplicationHelper

  # Public: create an icon for user
  #
  # Returns an html icon
  def user_icon(user)
    if user.role == "administrator" || user.role == "manager"
      "<i class='glyphicon glyphicon-tower'></i>".html_safe
    else
      "<i class='glyphicon glyphicon-user'></i>".html_safe
    end
  end

end
