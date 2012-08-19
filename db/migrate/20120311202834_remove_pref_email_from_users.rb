class RemovePrefEmailFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :pref_email
    remove_column :users, :addressID 
    remove_column :users, :educationID
    remove_column :users, :positionID 

    drop_table :subdomains
  end

  def down
  end
end
