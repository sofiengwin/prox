class AddPersonidToPeople < ActiveRecord::Migration
  def change
    add_column :people, :personid, :string
  end
end
