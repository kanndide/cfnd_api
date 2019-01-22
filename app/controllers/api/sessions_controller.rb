class Api::SessionsController < Devise::SessionsController
  respond_to :json
  include NoJSONRoot
  skip_before_action :verify_authenticity_token

  def create
    if params[:user][:uid].present?
      @authenticate = find_authentication
      if @authenticate.present?
        sign_in_user(@authenticate, "No #{@authenticate.provider} Auth")
      else
        render json: {error: "No uid params present for user"}, status: 401
      end
    else
      # self.resource = warden.authenticate!(auth_options)
      email = params[:user][:email] if params[:user]
      password = params[:user][:password] if params[:user]

      # Authentication
      @user=User.find_by_email(email)
      if @user
        if @user.valid_password? password
          self.resource=@user
          respond_with(resource, status: :created)
        else
          render json: {error: "Invalid Password"}, status: 422
        end
      else
        render json: {error: "Invalid Email"}, status: 422
      end
    end
  end

  def destroy
    current_api_user.authentication_token = nil
    super
  end

  private

  def find_authentication
    unless params[:user][:uid].present? and params[:user][:access_token].present?
      render json: {error: "No uid params present"}, status: 422
      return
    end

    @authenticate ||= Authentication.where(uid: params[:user][:uid] ).first

    if @authenticate
      @authenticate
    else
      @user = User.where(email: params[:user][:info][:email]).first
      if @user.present?
        @user.authentications.build({
                                                           provider: params[:user][:provider],
                                                           uid:params[:user][:uid],
                                                           access_token: params[:user][:access_token]
                                                })
      else
        pass = ('a'..'z').to_a.shuffle[0,8].join
        @user = User.new
        @user.email   = params[:user][:info][:email]
        @user.first_name = params[:user][:info][:first_name]
        @user.last_name = params[:user][:info][:last_name]
        @user.password = pass
        @user.password_confirmation = pass
        @user.authentications.build({
                                                    provider: params[:user][:provider],
                                                    uid:params[:user][:uid],
                                                    access_token: params[:user][:access_token]
                                                })
      end
      @user.save!
    end
    @authenticate = Authentication.where(uid: params[:user][:uid]).first

  end

  def sign_in_user(authenticate, error_message)
    if authenticate.present?
      self.resource = User.where(id: authenticate.user.id).first
      sign_in(resource)
      resource.reset_authentication_token!
      resource.save!
      respond_with resource, status: 201
    else
      render json: {error: error_message}, status: 401
    end
  end

end
