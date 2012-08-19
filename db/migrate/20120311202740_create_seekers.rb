class CreateSeekers < ActiveRecord::Migration
  def change
    create_table :seekers do |t|
      t.primary_key :id
      t.references :position_type
      t.references :education_level
      t.string :pref_email

      t.timestamps
    end
    add_index :seekers, :position_type_id
    add_index :seekers, :education_level_id
  end
end
