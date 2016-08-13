class PersonsController < ApplicationController
  include ApiConnection

  def create_person
    uri = "persongroups/#{params[:group]}/persons"
    body = {
      name: params[:name],
      user_data: params[:user_data]
    }.to_json
    response = json(make_api_call(uri, :post, body))
    if response[:error]
      render json: response
    else
      person = Person.create(
        name: params[:name],
        user_data: params[:user_data],
        personid: response[:personId]
      )
      render json: person
    end
  end

  def update_person
    person = Person.find_by(personid: params[:person_id])

    if person
      uri = "persongroups/#{params[:group]}/persons/#{params[:person_id]}"
      body = {
        name: params[:name],
        user_data: params[:user_data]
      }.to_json
      response = make_api_call(uri, :patch, body)
      response = {} if response == ""

      if response[:error]
        render json: response
      else
        person.update(
          name: params[:name],
          user_data: params[:user_data],
        )
        render json: person
      end
    else
      render json: { error: "Invalid personId"}
    end
  end

#list of persons in person group
  def list_persons
    uri = "persongroups/#{params[:group]}/persons"
    response = json(make_api_call(uri, :get))
    render json: response
  end

# list of persons in our db
  def get_persons
    @persons = Person.all
  end

  def get_person
    uri = "persongroups/#{params[:group]}/persons/#{params[:person_id]}"
    response = json(make_api_call(uri, :get))
    render json: response
  end
end
