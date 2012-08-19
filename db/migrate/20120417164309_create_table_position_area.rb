class CreateTablePositionArea < ActiveRecord::Migration
  def up
      create_table :position_areas do |t|
         t.primary_key :id
	 t.string      :area

	 t.timestamps
     end
  end

  def down
  end
end
