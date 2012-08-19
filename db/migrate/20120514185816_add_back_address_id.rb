class AddBackAddressId < ActiveRecord::Migration
  def up
  	add_column :addresses, :address_id, :integer
  end

  def down
  end
end
