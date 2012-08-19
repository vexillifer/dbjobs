class CreatePostingPositionJoinTable < ActiveRecord::Migration
  def up
    create_table :posting_positions, :id => false do |t|
      t.integer :post_id
      t.integer :position_id
    end
  end


  def down
      drop_table :posting_positions
  end
end
