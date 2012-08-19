class RemoveColumnFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :posted
      end

  def down
    add_column :posts, :posted, :string
  end
end
