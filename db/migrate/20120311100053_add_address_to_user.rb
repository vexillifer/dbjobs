class AddAddressToUser < ActiveRecord::Migration
  def change
    add_column :users, :addressID, :integer

  end
end
