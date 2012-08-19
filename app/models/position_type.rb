class PositionType < ActiveRecord::Base
	attr_accessible :all

	has_many :posting_positions
	has_many :posts, :through => :posting_positions

	has_many :job_pref_positions
	has_many :job_preferences, :through => :job_pref_positions
end
