class FixAddressBuilding < ActiveRecord::Migration
  def up
  	add_column :addresses, :post_id, :integer
  	remove_column :addresses, :id
  	remove_column :posts, :address_id
  end

  def down
  	rename_column :addresses, :address_id, :id
  	add_column :posts, :address_id, :integer
  end
end
