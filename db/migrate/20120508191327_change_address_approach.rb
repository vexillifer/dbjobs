class ChangeAddressApproach < ActiveRecord::Migration
  def up
  	remove_column :job_preferences, :address_id
  	add_column :job_preferences, :address, :string
  end

  def down
  end
end
