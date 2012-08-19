class RemovePublicColumnFromUsers < ActiveRecord::Migration
  def up
  	remove_column :users, :public
  end

  def down
  end
end
