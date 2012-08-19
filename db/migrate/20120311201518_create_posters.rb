class CreatePosters < ActiveRecord::Migration
  def change
    create_table :posters do |t|
      t.primary_key :id
      t.boolean :approved, :default => false

      t.timestamps
    end
  end
end
