class AddPositionAreaColumnToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :position_area, :integer

  end
end
