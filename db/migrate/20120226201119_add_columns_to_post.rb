class AddColumnsToPost < ActiveRecord::Migration
  def change
    add_column :posts, :title, :string
    add_column :posts, :description, :text

  end
end
