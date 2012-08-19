class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :id
      t.references :poster
      t.date :start
      t.date :expiry
      t.integer :status, :default => 2 
      t.date :posted

      t.timestamps
    end
    add_index :posts, :id
  end
end
