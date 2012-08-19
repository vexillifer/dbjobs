class AddLinkedInTextToProfiles < ActiveRecord::Migration
  def up
    add_column :profiles, :linkedin, :text

  end
  def drop
  	remove_column :profiles, :linkedin
  end
end
