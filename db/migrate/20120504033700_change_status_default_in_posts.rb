class ChangeStatusDefaultInPosts < ActiveRecord::Migration
  def up
      change_column :posts, :status, :integer, :default => 0
  end

  def down
  end
end
