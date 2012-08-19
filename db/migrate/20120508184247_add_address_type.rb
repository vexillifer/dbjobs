class AddAddressType < ActiveRecord::Migration
  def up
  	
  end

  def down
  	remove_column :addresses, :type
  end
end
