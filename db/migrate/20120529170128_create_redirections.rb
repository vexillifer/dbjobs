class CreateRedirections < ActiveRecord::Migration
  def change
    create_table :redirections, :id => false do |t|
      t.integer :from_post
      t.integer :to_post
    end

    add_index :redirections, [:from_post, :to_post], :unique => true
  end

  def down
  	drop_table :redirections
  end
end
