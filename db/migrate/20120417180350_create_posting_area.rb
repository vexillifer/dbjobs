class CreatePostingArea < ActiveRecord::Migration
  def up
      create_table :posting_areas, :id => false do |t|
      	t.integer :post_id
	t.integer :postition_area_id
      end
  end

  def down
      drop_table :posting_areas
  end
end
