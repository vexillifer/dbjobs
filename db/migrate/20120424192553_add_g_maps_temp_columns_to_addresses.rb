class AddGMapsTempColumnsToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :gCountry, :string

    add_column :addresses, :gProvStat, :string

  end
end
