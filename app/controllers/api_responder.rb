class ApiResponder < ActionController::Responder
  include Responders::HttpCacheResponder

  def display(resource, options = {})
    options.delete :location
    super(resource, options)
  end

  def json_resource_errors
    { error: resource.errors.full_messages.first }
  end

  def to_json
    @options[:status] = :created if post?
    to_format
  end

end