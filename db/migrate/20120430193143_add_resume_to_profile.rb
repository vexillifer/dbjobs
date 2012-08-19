class AddResumeToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :resume, :binary
  def down
    drop_column :profiles, :resume
  end
  end
end
