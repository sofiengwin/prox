json.array! @persons do |person|
  json.name person[:person].name
  json.image_link person[:person].faces.first.image_link
  json.confidence person[:result][:confidence]
end
