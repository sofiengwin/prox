module Navigation
  class Parser < Direction
    attr_reader :total_travel_time, :total_distance, :warnings, :total_legs, :first_leg
    def initialize(nav_payload)
      @raw_payload = nav_payload.first
      @warnings = @raw_payload[:warnings]
      setup_legs(@raw_payload)
    end

    def setup_legs(payload)
      count = 0
      payload[:legs].each do |leg|
        if first_leg
          first_leg.follow_up(leg)
        else
          @first_leg = Leg.create(leg)
        end
        count += 1
      end
      @total_legs = count
    end
  end
end
