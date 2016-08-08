class ResponseHandler
  attr_reader :response, :resource, :fields
  def initialize(response, resource = nil, fields = {})
    @response = response
    @resource = resource
    @fields = fields
  end

  def call
    return response if response[:error]
    return creator(resource, fields) if resource
    response
  end

  def creator(resource, fields)
    resource.create(fields)
  end
end
