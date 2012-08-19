class CreateJobPreferences < ActiveRecord::Migration
  def change
    create_table :job_preferences do |t|
      t.integer :education_level
      t.integer :address

      t.timestamps
    end
  end
end
