class PersonGroupsController < ApplicationController
  include ApiConnection
  def create_group
    uri = "persongroups/#{params[:name]}"
    body = {
      name: params[:name],
      userData: "First group"
    }.to_json
    response = make_api_call(uri, :put, body)
    response = json(response)
    if response[:error]
      render json: response
    else
      person_group = PersonGroup.create(name: params[:name])
      render json: person_group
    end
  end
end
