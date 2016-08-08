require 'rails_helper'

RSpec.describe FacesController, type: :request do
  describe "POST add_face" do
    it "returns newly created face" do
      person = Person.last
      image_link = "http://mediamass.net/jdd/public/documents/celebrities/2539.jpg"
      post(
        "/person-groups/theprox/persons/#{person.personid}/faces",
        {
          image_link: image_link
        },
        format: :json
      )

      expect(json(response.body)[:image_link]).to eq image_link
    end
  end
end
