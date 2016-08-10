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

  def get_faces
    person = Person.find_by(personid: params[:person_id])
    faces = person.faces
    render json: faces
  end

  def detect
    body = {
      url: params[:image_link]
    }.to_json
    response = json(make_api_call("detect", :post, body))
    face_id = response[0][:faceId]
    @result = verify(identify(face_id))
  end

  private

  def identify(face_id)
    body = {
      personGroupId: "theprox",
      faceIds: [face_id],
      maxNumOfCandidatesReturned: 1,
      confidenceThreshold: 0.75
    }.to_json

    response = json(make_api_call("identify", :post, body))
  end

  def verify(face_params)
    if face_params.is_a? Array
      body = {  "faceId": face_params[0][:faceId],
                "personId": face_params[0][:candidates][0][:personId],
                "personGroupId": "theprox"
             }.to_json
      @person = Person.find_by(
        personid: face_params[0][:candidates][0][:personId]
      )
      json(make_api_call("verify", :post, body))
    else
      face_params
    end
  end

  def add_new_face
    uri = "persongroups/#{params[:group]}/persons/#{params[:person_id]}/persistedFaces"
    body = {
      url: params[:image_link]
    }.to_json
    @response = json(make_api_call(uri, :post, body))
    @fields = { image_link: params[:image_link],
                persisted_face_id: @response[:persistedFaceId]
             }
  end

  def set_person
    Person.find_by(personid: params[:person_id])
  end
end
