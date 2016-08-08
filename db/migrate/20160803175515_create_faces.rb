class CreateFaces < ActiveRecord::Migration
  def change
    create_table :faces do |t|
      t.string :image_link
      t.string :persisted_face_id
      t.references :person, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
