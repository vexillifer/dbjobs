class AddColumnsToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :lat, :float

    add_column :addresses, :long, :float

  end
end
