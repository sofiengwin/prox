module ApiConnection
  def make_api_call(uri_extension, http_method, body = '{}')
    url = ENV["face_api"] + uri_extension
    conn = Faraday.new(url: url).send(http_method) do |req|
      req.headers["Content-Type"] = "application/json"
      req.headers["Ocp-Apim-Subscription-Key"] = ENV["face_subscription_key"]
      req.body = body
    end
    conn.body
  end

  def json(response)
    JSON.parse(response, symbolize_names: true)
  end
end
