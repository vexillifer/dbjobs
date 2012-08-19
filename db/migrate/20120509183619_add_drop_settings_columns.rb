class AddDropSettingsColumns < ActiveRecord::Migration
  def up
  	remove_column :profiles, :public
  	remove_column :job_preferences, :visible
  	remove_column :job_preferences, :searchable
    add_column :profiles, :public, :boolean, :default => 'true'
    add_column :job_preferences, :visible, :boolean, :default => 'true'
    add_column :job_preferences, :searchable, :boolean, :default => 'true'
  end

  def down
  end
end
