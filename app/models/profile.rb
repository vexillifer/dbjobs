class Profile < ActiveRecord::Base

	belongs_to :user

	has_attached_file :resume, :content_type => { :content_type => "application/pdf" },
		:path => ":rails_root/public/assets/resumes/:id/:basename.:extension"

end