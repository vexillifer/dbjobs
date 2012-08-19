class AddBioToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :bio, :text
    remove_column :users, :bio

  end
end
