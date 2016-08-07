GoogleMapsService.configure do |config|
  config.key = ENV['GMAPS_KEY']
  config.retry_timeout = 20
  config.queries_per_second = 10
end
