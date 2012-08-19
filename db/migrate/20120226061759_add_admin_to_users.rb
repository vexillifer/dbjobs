class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :utype, :integer, :default => 2

  end
end
