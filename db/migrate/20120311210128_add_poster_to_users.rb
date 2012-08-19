class AddPosterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :poster, :integer

  end
end
