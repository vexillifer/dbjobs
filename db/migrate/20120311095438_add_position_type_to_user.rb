class AddPositionTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :positionID, :integer

  end
end
