module Navigation
  class Direction
    attr_reader :instruction, :classname
    def self.inherited(base)
      cname = base.name.match(/.*::(\w+)/)[1].downcase
      base.instance_variable_set('@classname', cname)
    end

    def print_direction
      puts get_directions
    end

    def nested_segement(name)
      segements = {
        "parser" => "first_leg",
        "leg" => "first_step"
      }
      segements[name]
    end

    def get_directions
      @classname ||= self.class.instance_variable_get('@classname')
      ActionView::Base.full_sanitizer.sanitize("#{instruction}\n#{get_nested_segement}\n#{get_next_segement}")
    end

    def get_nested_segement
      seg = nested_segement(classname)
      if seg
        seg_ref = send(seg)
        seg_ref.get_directions if seg_ref
      end
    end

    def get_next_segement
      next_seg = "next_#{classname}"
      if respond_to? next_seg
        seg_ref = send(next_seg)
        seg_ref.get_directions if seg_ref
      end
    end
  end
end
