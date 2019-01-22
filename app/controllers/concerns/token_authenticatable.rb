module TokenAuthenticatable

  extend ActiveSupport::Concern
  module ClassMethods
    def authenticated!(options = {})
      prepend_before_action :authenticate_user_from_token!, options
      before_action :authenticate_api_user!, options
    end
  end

  private

  def authenticate_user_from_token!
    authenticate_or_request_with_http_token do |token, options|
      @user = User.find_by(authentication_token: token)
      if @user && Devise.secure_compare(@user.authentication_token, token)
        logger.info "User Authentication"
        sign_in :api_user, @user, store: false
      end
    end
  end

end
