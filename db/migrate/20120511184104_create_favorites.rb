class CreateFavorites < ActiveRecord::Migration
  def up
    create_table :favourites, :id => false do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end
  end

  def down
  	drop_table :favorites
  end
end
