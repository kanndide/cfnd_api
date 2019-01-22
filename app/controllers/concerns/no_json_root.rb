module NoJSONRoot

  extend ActiveSupport::Concern
  def default_serializer_options
    { root: false }
  end

end