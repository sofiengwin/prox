class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :user_data
      t.references :person_group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
