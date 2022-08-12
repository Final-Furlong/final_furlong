module JSONHelpers
  def json_body
    JSON.parse(response.body)
  end

  def serialize(model:, stringify: true)
    serialize_class = "#{model.class.name}Serializer".constantize
    attributes = serialize_class.new(model).attributes
    attributes.stringify_keys if stringify
  end
end

