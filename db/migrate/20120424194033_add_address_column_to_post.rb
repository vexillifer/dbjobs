class AddAddressColumnToPost < ActiveRecord::Migration
  def change
    add_column :posts, :address, :integer

  end
end
