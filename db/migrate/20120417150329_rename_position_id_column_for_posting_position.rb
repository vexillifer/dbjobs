class RenamePositionIdColumnForPostingPosition < ActiveRecord::Migration
  def up
      rename_column :posting_positions, :position_id, :position_type_id
  end

  def down
  end
end
