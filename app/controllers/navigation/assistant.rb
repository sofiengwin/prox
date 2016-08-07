module Navigation
  class Assistant
    attr_reader :result, :gmaps

    def initialize
      @gmaps = GoogleMapsService::Client.new
    end

    def parse
      Parser.new(result)
    end

    def directions(from, to)
      @result = gmaps.directions(from, to, alternatives: false)
    end
  end
end
