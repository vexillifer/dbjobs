class DropScrapeTable < ActiveRecord::Migration
  def up
  	drop_table :scrape_logs
  end

  def down
  end
end
