module Authorization

  protected

    def authorize_management
      unless user_signed_in? && current_user.management?
        authorize_failed_url
      end
    end

    def authorize_administrater
      unless user_signed_in? && current_user.administrater?
        authorize_failed_url
      end
    end

    def authorize_user
      unless user_signed_in? && (yield current_user)
        authorize_failed_url
      end
    end

    def authorize_failed_url
      redirect_to root_url, alert: "You are not authorized to do this."
      return
    end
end
