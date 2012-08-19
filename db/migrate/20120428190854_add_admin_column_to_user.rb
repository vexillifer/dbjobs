class AddAdminColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean

  end

  def down
    drop_column :users, :admin, :boolean
  end
end
