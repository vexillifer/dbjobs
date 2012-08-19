class CreateJobPrefPositions < ActiveRecord::Migration
  def up
    create_table :job_pref_positions, :id => false do |t|
      t.integer :position_type_id
      t.integer :job_preference_id

    end
  end

  def down
  	drop_table :job_pref_positions
  end
end
