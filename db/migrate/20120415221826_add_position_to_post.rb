class AddPositionToPost < ActiveRecord::Migration
  def change
    add_column :posts, :position_type, :integer

  end
end
