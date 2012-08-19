class RenameAddressColumnJobPreferences < ActiveRecord::Migration
  def up
  	rename_column :job_preferences, :address, :address_id
  end

  def down
  end
end
