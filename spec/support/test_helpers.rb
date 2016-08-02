module Test
  module Helpers
    def json(response)
      JSON.parse(response, symbolize_names: true)
    end
  end
end
