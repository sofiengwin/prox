class Person < ActiveRecord::Base
  belongs_to :person_group
  has_many :faces
end
