class RemoveColumnsFromAddresses < ActiveRecord::Migration
  def up
      remove_column :addresses, :prov_stateID
      remove_column :addresses, :postal
      remove_column :addresses, :countryID
      remove_column :addresses, :gCountry
      remove_column :addresses, :gProvStat
  end

  def down
  end
end
