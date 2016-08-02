Rails.application.routes.draw do
  get "new-person-group", to: "person_groups#create_group"
end
