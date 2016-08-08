require 'rails_helper'

RSpec.describe FacesController, type: :request do
  before :each do
    post(
        "/person-groups/theprox/new-person",
        { name: "goodluck jonathan", userData: "From bayelsa state" },
        format: :json
      )
  end

  after :each do
    Person.destroy_all
  end

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

  describe "POST detect" do
    it "returns an error response with invalid params" do
      person = Person.last
      post("/person-groups/theprox/persons/#{person.personid}/detect_face",
          {
            faceIds: ["dsfdsafdsfdfsdfdsf"],
            personGroupId: "theprox"
          },
        format: :json
        )
      expect(json(response.body).keys).to include "error"
    end
  end
end
