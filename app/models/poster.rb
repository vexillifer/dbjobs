class Poster < ActiveRecord::Base
	has_one :users
	has_many :posts

	attr_accessible :approved
end
