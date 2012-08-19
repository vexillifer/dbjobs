class RenameStreetColumnAddresses < ActiveRecord::Migration
  def up
      rename_column :addresses, :street, :address
  end

  def down
  end
end
