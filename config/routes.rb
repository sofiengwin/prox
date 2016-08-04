Rails.application.routes.draw do
  get "new-person-group", to: "person_groups#create_group"


  # Person
  get "person-groups/:group/new-person", to: "persons#create_person"
  get "person-groups/:group/persons", to: "persons#list_persons"
  get "person-groups/:group/persons/:person_id", to: "persons#get_person"
  put "person-groups/:group/persons/:person_id", to: "persons#update_person"

  # Faces
  post "person-groups/:group/persons/:person_id/faces", to: "faces#add_face"
end
