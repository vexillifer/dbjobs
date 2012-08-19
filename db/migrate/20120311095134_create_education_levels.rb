class CreateEducationLevels < ActiveRecord::Migration
  def up
    create_table :education_levels do |t|
      t.primary_key :id
      t.string :education

      t.timestamps
    end
  end
end
