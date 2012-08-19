class AddFieldsToProfile < ActiveRecord::Migration
  def change
  	add_column :profiles, :linkedin_url, :string
  	add_column :profiles, :personal_url, :string
  	add_column :profiles, :dblp_url, :string 
  end
end
