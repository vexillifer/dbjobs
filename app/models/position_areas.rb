class PositionArea < ActiveRecord::Base
	attr_accessible :all

	has_many :posting_areas
	has_many :posts, :through => :posting_areas
end
