module JSONErrorHandling

  extend ActiveSupport::Concern
  included do
    rescue_from(ActionController::ParameterMissing) do |e|
      render json: { error: e.message.capitalize }, status: 400
    end
    rescue_from(ActiveRecord::RecordNotFound) do |e|
      render json: { error: e.message }, status: 404
    end
  end

end