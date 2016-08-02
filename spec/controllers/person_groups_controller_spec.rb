require 'rails_helper'

RSpec.describe PersonGroupsController, type: :request do
  describe "GET create_group" do
    it "returns details for the newly created group" do
      get(
        "/new-person-group",
        { name: "andela", user_data: "First andela group" },
        format: :json
        )

        expect(json(response.body)[:error][:message]).to eq(
          "Person group 'andela' already exists."
        )
    end
  end
end
