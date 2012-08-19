class AddCountryStatColumnsToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :country_code, :string

    add_column :addresses, :state_code, :string

  end
end
