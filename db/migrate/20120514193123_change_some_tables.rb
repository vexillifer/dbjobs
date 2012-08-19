class ChangeSomeTables < ActiveRecord::Migration
  def up
  	remove_column :addresses, :post_id
  	add_column :addresses, :id, :primary_key
  	add_column :posts, :address_id, :integer
  end

  def down
  end
end
