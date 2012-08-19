class AddUserIdToJobPreference < ActiveRecord::Migration
  def change
    add_column :job_preferences, :user_id, :integer

  end
end
