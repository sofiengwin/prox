class FacesController < ApplicationController
  include ApiConnection

  def add_face
    person = Person.find_by(personid: params[:person_id])
    uri = "persongroups/#{params[:group]}/persons/#{params[:person_id]}/persistedFaces"
    body = {
      url: params[:image_link]
    }.to_json

    response = json(make_api_call(uri, :post, body))
    if response[:error]
      render json response
    else
      face = person.faces.create(
        image_link: params[:image_link],
        persisted_face_id: response[:persistedFaceId]
        )
      render json: face
    end
  end

  def get_faces
    faces = Faces.where(personid: params[:person_id])
    render json: faces
  end
end
