class CreateScrapeLogs < ActiveRecord::Migration
  def change
    create_table :scrape_logs do |t|
      t.date :dbworld_date
      t.integer :post
      t.string :email

      t.timestamps
    end
  end
end
