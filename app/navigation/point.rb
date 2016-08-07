module Navigation
  class Point
    attr_reader :lat, :long, :addr
    alias_method :address, :addr

    def initialize(info, desc=nil)
      @lat = info[:lat]
      @long = info[:lng]
      @addr = desc
    end

    def details
      {
        address: addr,
        coords: coords
      }
    end

    def coords
      {lat: lat, long: long}
    end
  end
end
