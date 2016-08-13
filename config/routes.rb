Rails.application.routes.draw do
  get "new-person-group", to: "person_groups#create_group"


  # Person
  post "person-groups/:group/new-person", to: "persons#create_person"
  get "person-groups/:group/persons", to: "persons#list_persons"
  get "persons", to: "persons#get_persons"
  get "person-groups/:group/persons/:person_id", to: "persons#get_person"
  put "person-groups/:group/persons/:person_id", to: "persons#update_person"

  # Faces
  post "person-groups/:group/persons/:person_id/faces", to: "faces#add_face"
  post "person-groups/:group/detect-face", to: "faces#detect_face"
  get "person-groups/:group/persons/:person_id/faces", to: "faces#get_faces"
  post "person-groups/:group/identify", to: "faces#detect"
end
