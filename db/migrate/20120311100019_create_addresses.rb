class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.primary_key :id
      t.string :street
      t.string :city
      t.integer :prov_stateID
      t.string :postal
      t.integer :countryID

      t.timestamps
    end
  end
end
