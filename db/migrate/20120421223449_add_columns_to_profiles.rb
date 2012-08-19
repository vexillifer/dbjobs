class AddColumnsToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :name, :string

    add_column :profiles, :pref_email, :string

    add_column :profiles, :phone, :string

  end
end
