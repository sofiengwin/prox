class CreatePersonGroups < ActiveRecord::Migration
  def change
    create_table :person_groups do |t|
      t.string :name
      t.string :user_data

      t.timestamps null: false
    end
  end
end
