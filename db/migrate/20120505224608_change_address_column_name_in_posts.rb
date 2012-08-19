class ChangeAddressColumnNameInPosts < ActiveRecord::Migration
  def up
      rename_column :posts, :address, :address_id
  end

  def down
  end
end
