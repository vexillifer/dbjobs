class CreatePositionTypes < ActiveRecord::Migration
  def change
    create_table :position_types do |t|
      t.primary_key :id
      t.string :position

      t.timestamps
    end
  end
end
