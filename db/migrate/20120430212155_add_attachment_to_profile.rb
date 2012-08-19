class AddAttachmentToProfile < ActiveRecord::Migration
  def change
      change_table :profiles do |t|
      		   t.has_attached_file :resume
      end
  end
end
