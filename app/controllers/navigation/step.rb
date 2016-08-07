module Navigation
  class Step < Direction
    attr_reader :prev_step, :details, :next_step, :duration, :distance

    def self.create(info)
      new(info, nil)
    end

    def initialize(params, parent)
      @prev_step = parent
      @details = params
      @duration = details[:duration]
      @distance = details[:distance]
      setup_location(details)
    end

    def setup_location(info)
      @start_point = Point.new(info[:start_location])
      @end_point = Point.new(info[:end_location])
    end

    def follow_up(step)
      if next_step
        next_step.follow_up(step)
      else
        @next_step = Step.new(step, self)
      end
    end

    def instruction
      @details[:html_instructions] + " approximately #{distance[:text]}"
    end

    def travel_mode
      @details[:travel_mode]
    end

    def maneuver
      @details[:maneuver]
    end
  end
end
