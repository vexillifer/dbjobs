class RenamePostingAreaColumn < ActiveRecord::Migration
  def up
      rename_column :posting_areas, :postition_area_id, :position_area_id
  end

  def down
  end
end
