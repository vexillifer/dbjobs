class EmploymentClass < ActiveRecord::Base
	attr_accessible :all

	has_many :posts
end
