module ApiConnection
  def make_api_call(uri_extension, http_method, body = '')
    url = ENV["face_api"] + uri_extension
    conn = Faraday.new(url: url).send(http_method) do |req|
      req.headers["Content-Type"] = "application/json"
      req.headers["Ocp-Apim-Subscription-Key"] = ENV["face_subscription_key"]
      req.body = body
    end
    conn.body
  end

  def call_object_detect_api(image_path)
    url = ENV["object_api"]
    key = ENV["object_api_subscription_key"]

    result = api_connection_with_image(url, key, image_path)
  end

  def api_connection_with_image(url, key, image_path)
    body = {url: Faraday::UploadIO.new(image_path, 'image/jpeg')}

    conn = Faraday.new(url) do |faraday|
      faraday.request :multipart
      faraday.request :url_encoded
      faraday.adapter :net_http
    end

    result = conn.post do |req|
                req.headers["Ocp-Apim-Subscription-Key"] = key
                req.body = body
              end
    json(result.body)
  end

  def json(response)
    JSON.parse(response, symbolize_names: true)
  end
end
