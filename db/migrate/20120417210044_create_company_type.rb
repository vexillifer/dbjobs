class CreateCompanyType < ActiveRecord::Migration
  def up
      create_table :company_types do |t|
        t.primary_key :id
	t.string      :type

	t.timestamps
      end
  end

  def down
  end
end
