class AddLinkedinUrLtoProfiles < ActiveRecord::Migration
  def up
  	add_column :profiles, :linkedin_url, :string
  end

  def down
  	remove_column :profiles, :linkedin_url
  	
  end
end
