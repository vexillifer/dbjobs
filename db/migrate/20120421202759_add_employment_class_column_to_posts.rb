class AddEmploymentClassColumnToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :employment_class, :integer

  end
end
