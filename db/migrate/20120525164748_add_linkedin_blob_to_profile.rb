class AddLinkedinBlobToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :linkedin, :binary

  end

  def down
  		remove_column :profiles, :linkedin
  end
end
