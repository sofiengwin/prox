module Navigation
  class Leg < Direction
    attr_reader :duration, :distance, :total_steps, :details, :start_point, :end_point, :next_leg, :prev_leg, :first_step

    def self.create(info)
      new(info, nil)
    end

    def initialize(params, parent)
      @details = params
      @prev_leg = parent
      @duration = details[:duration]
      @distance = details[:distance]
      setup_points(details)
      setup_steps(details)
    end

    def setup_points(info)
      @start_point = Point.new(info[:start_location], info[:start_address])
      @end_point = Point.new(info[:end_location], info[:end_address])
    end

    def setup_steps(info)
      count = 0
      info[:steps].each do |step|
        if first_step
          first_step.follow_up(step)
        else
          @first_step = Step.create(step)
        end
        count += 1
      end
      @total_steps = count
    end

    def follow_up(leg)
      if next_leg
        next_leg.follow_up(leg)
      else
        @next_leg = Leg.new(leg, self)
      end
    end

    def instruction
      "This leg will take you from #{start_point.addr} up to #{end_point.addr}. It should take approximately #{duration[:text]}"
    end
  end
end
