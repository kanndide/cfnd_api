class Api::ApiController < ApplicationController

  respond_to :json
  self.responder = ApiResponder
  include NoJSONRoot
  include JSONErrorHandling
  include TokenAuthenticatable
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  skip_before_action :verify_authenticity_token

  def current_user
    current_api_user
  end

  rescue_from(ActionController::ParameterMissing) do |e|
    render json: { Message: e.message.capitalize, StatusCode: 400, Data: nil }, status: 400
  end
  rescue_from(ActiveRecord::RecordNotFound) do |e|
    render json: { Message: e.message, StatusCode: 404, Data: nil }, status: 404
  end

  rescue_from StandardError do |e|
    render json: { Message: e.message, StatusCode: 500, Data: nil }, status: 500
  end

end
