class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Add additional parameters to devise user
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Authenticate
  def authenticate_role!(*roles)
    auth = authenticate_user!

    case roles.length
    when 0
      auth
    when 1
      roles[0] == current_user.role
    else
      roles.include? current_user.role
    end
  end

  protected

  # Add more user parameters permitted
  def configure_permitted_parameters
    # sign up
    devise_parameter_sanitizer.for(:sign_up) << :username
    devise_parameter_sanitizer.for(:sign_up) << :birthday
    devise_parameter_sanitizer.for(:sign_up) << :phone

    # edit account
    devise_parameter_sanitizer.for(:account_update) << :username
    devise_parameter_sanitizer.for(:account_update) << :birthday
    devise_parameter_sanitizer.for(:account_update) << :phone
  end
end
