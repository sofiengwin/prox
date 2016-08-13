if @person
json.name @person.name
json.image_link @person.faces.first.image_link
json.confidence @result[:confidence]
else
  json.error @result[:error]
end
