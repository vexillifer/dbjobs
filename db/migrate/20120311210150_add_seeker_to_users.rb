class AddSeekerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :seeker, :integer

  end
end
