class EducationLevel < ActiveRecord::Base
	has_many :posts
	attr_accessible :all


end
