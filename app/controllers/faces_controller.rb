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
    @persons = []
    body = {
      url: params[:image_link]
    }.to_json
    face_ids = detect_faces(body)
    identified = identified_person(face_ids)
    if identified.any? {|person| person.keys.include? :error }
      render json: ResponseHandler.new(identified).call
    end
    verify_face(identified)
  end

  private

  def verify_face(faces)
    faces.each do |face|
      @persons << verify(face) unless face[:candidates].empty?
    end
  end

  def detect_faces(body)
    response = json(make_api_call("detect", :post, body))
    if response.is_a?(Array)
      response.map{ |response| response[:faceId] }
    else
      { error: "Invalid image link"}
    end
  end

  def identified_person(face_ids)
    response = identify(face_ids)
    if response.is_a?(Array)
      response
    else
      { error: "No person matched."}
    end
  end

  def identify(face_ids)
    body = {
      personGroupId: "theprox",
      faceIds: face_ids,
      maxNumOfCandidatesReturned: 1,
      confidenceThreshold: 0.75
    }.to_json

    json(make_api_call("identify", :post, body))
  end

  def verify(face_params)
    if face_params[:candidates].is_a?(Array)
      body = {  faceId: face_params[:faceId],
                personId: face_params[:candidates][0][:personId],
                personGroupId: "theprox"
             }.to_json
      person = Person.find_by(
        personid: face_params[:candidates][0][:personId]
      )
      result = json(make_api_call("verify", :post, body))
      { person: person, result: result }
    else
      {error: "Person not found"}
    end
  end

  def handle_error(error_message)
    if error_message[:error]
      error_message
    else
      { error: "alternative error message" }
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
