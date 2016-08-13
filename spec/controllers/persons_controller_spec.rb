require 'rails_helper'

RSpec.describe PersonsController, type: :request do
    after(:all) do
      Person.destroy_all
    end
  describe "GET create_person" do
    context "with valid details" do
      it "returns the details of the newly created person" do
        post(
          "/person-groups/theprox/new-person",
          { name: "goodluck jonathan", userData: "From bayelsa state" },
          format: :json
        )

        expect(json(response.body)[:name]).to eq "goodluck jonathan"
      end
    end

    context "with invalid details" do
      it "returns error message" do
        post(
          "/person-groups/theprox/new-person",
          { name: nil, userData: nil},
          format: :json
        )

        expect(json(response.body).keys).to  include :error
      end
    end
  end

  describe "PUT update_person" do
    it "returns an empty response" do
      person = Person.last
      put(
        "/person-groups/theprox/persons/#{person.personid}",
        { name: "goodluck", userData: "From bayelsa state" },
        format: :json
      )
      expect(json(response.body)[:name]).to eq "goodluck"
    end
  end

  describe "GET list_persons" do
    it "returns a list of people in a person group" do
      get("/person-groups/theprox/persons", format: :json)
      expect(json(response.body)[0][:name]).to eq "goodluck jonathan"
    end
  end

  describe "GET get_person" do
    it "returns person details" do
      person = Person.last
      get(
      "/person-groups/theprox/persons/#{person.personid}",
      format: :json
      )
      expect(json(response.body)[:name]).to eq "goodluck"
    end
  end
end
