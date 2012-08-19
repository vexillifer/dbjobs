class AddPrefEmailToUser < ActiveRecord::Migration
  def change
    add_column :users, :pref_email, :string

  end
end
