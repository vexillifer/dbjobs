class AddApprovedPosterColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :approved_poster, :boolean, :default => false

  end
end
