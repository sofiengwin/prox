class PersonGroupsController < ApplicationController
  include ApiConnection
  def create_group
    uri = "persongroups/#{params[:name]}"
    body = {
      name: params[:name],
      userData: "First group"
    }.to_json
    response = json(make_api_call(uri, :put, body))
    render json: ResponseHandler.new(response, PersonGroup, name: params[:name]).call
  end
end
