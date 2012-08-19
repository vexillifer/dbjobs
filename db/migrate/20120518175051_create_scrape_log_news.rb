class CreateScrapeLogNews < ActiveRecord::Migration
  def change
    create_table :scrape_logs do |t|
      t.date :dbworld_date
      t.string :dbworld_link
      t.integer :post_id
      t.integer :user_id

      t.timestamps
    end
  end
end
