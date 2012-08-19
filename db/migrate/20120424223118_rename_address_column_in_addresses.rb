class RenameAddressColumnInAddresses < ActiveRecord::Migration
  def up
      rename_column :addresses, :address, :street
  end

  def down
  end
end
