class FacesController < ApplicationController
  before_action :add_new_face, only: [:add_face, :detect_face]
  include ApiConnection

  def add_face
    render json: ResponseHandler.new(@response, set_person.try(:faces), @fields).call
  end

  def get_faces
    faces = Faces.where(personid: params[:person_id])
    render json: faces
  end

  def detect_face
    face = ResponseHandler.new(@response, set_person.faces, @fields).call
    face_id = face.try(:persisted_face_id)
    body = {
              "personGroupId": "theprox",
              "faceIds": [face_id],
              "maxNumOfCandidatesReturned": 1,
              "confidenceThreshold": 0.75
           }.to_json
    verified_resp = verify(json(make_api_call("identify", :post, body)))
    render json: ResponseHandler.new(verified_resp).call
  end

  private

  def verify(face_params)
    unless face_params[:error]
      body = {  "faceId": face_params[0]["faceId"],
                "personId": face_params[0]["candidates"][0]["personId"],
                "personGroupId": "theprox"
             }
      json(make_api_call("verify", :post, body))
    end
    face_params if face_params[:error]
  end

  def add_new_face
    uri = "persongroups/#{params[:group]}/persons/#{params[:person_id]}/persistedFaces"
    body = {
      url: params[:image_link]
    }.to_json
    @response = json(make_api_call(uri, :post, body))
    @fields = { image_link: params[:image_link],
                persisted_face_id: response[:persistedFaceId]
             }
  end

  def set_person
    Person.find_by(personid: params[:person_id])
  end
end
