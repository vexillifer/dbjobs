class AddEducationLevelToUser < ActiveRecord::Migration
  def change
    add_column :users, :educationID, :integer

  end
end
