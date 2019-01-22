class Api::PasswordsController < Devise::PasswordsController
  skip_before_action :verify_authenticity_token
  respond_to :json, :html
  def create
    self.resource = Account.find_by(email: params[:api_account][:email])
    if resource
      resource_class.send_reset_password_instructions(resource_params)
      head 201
    else
      head 404
    end
  end
end