class RemovePositionTypeColumnFromPost < ActiveRecord::Migration
  def up
  end

  def down
      remove_column :posts, :position_type
  end
end
