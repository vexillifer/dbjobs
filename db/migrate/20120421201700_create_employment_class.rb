class CreateEmploymentClass < ActiveRecord::Migration
  def up
      create_table :employment_classes do |t|
      	t.string   :classification
	t.timestamps
      end
  end

  def down
  end
end
