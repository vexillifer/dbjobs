class AddVisibleColumnToJobPreferences < ActiveRecord::Migration
  def change
    add_column :job_preferences, :visible, :boolean, :default => 'true'
    add_column :job_preferences, :searchable, :boolean, :default => 'true'
  end
end
