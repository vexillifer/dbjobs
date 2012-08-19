class AddAttachmentToPost < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.has_attached_file :info
    end
  end
end
