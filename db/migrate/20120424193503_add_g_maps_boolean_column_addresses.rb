class AddGMapsBooleanColumnAddresses < ActiveRecord::Migration
  def up
      add_column :addresses, :gmaps, :boolean
      rename_column :addresses, :lat, :latitude
      rename_column :addresses, :long, :longitude
  end

  def down
  end
end
