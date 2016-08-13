json.array! @persons do |person|
  json.extract! person, :id, :name, :personid
  unless person.faces.empty?
    json.image_link person.faces.first.image_link
  else
    json.image_link "https://placeimg.com/640/480/people"
  end
end
