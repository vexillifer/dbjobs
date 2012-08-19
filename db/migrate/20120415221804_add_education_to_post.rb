class AddEducationToPost < ActiveRecord::Migration
  def change
    add_column :posts, :education_level, :integer

  end
end
