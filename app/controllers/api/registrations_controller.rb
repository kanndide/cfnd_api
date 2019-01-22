class Api::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  include NoJSONRoot
  include TokenAuthenticatable
  skip_before_action :verify_authenticity_token

  authenticated! only: :update

  def create
    build_resource(create_params)
    resource.authentication_token = Devise.friendly_token
    if resource.save
      sign_up(resource_name, resource)
      respond_with(resource, status: :created)
    else
      warden.custom_failure!
      respond_with resource, status: 422
    end
  end


  def update
    self.resource = current_api_user
    successfully_updated = if needs_password?
      resource.update_with_password(update_params)
    else
      resource.update_without_password(update_params.except(:current_password))
    end

    if successfully_updated
      sign_in resource, bypass: true
      respond_with resource
    else
      respond_with resource
    end
  end

  protected

  def create_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :profile_image, :password_confirmation)
  end

  def update_params
     params.require(:user).permit(:email, :password, :first_name, :last_name, :profile_image, :password_confirmation)
  end

  def needs_password?
    params[:user][:password].present?
  end

end