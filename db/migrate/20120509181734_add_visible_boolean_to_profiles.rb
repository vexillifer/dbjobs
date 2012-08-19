class AddVisibleBooleanToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :public, :boolean, :default => 'true'

  end
end
