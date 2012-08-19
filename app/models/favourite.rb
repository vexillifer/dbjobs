class Favourite < ActiveRecord::Base
	belongs_to :post
	belongs_to :user

	# Keep favorite unique
	validates_uniqueness_of :post_id, :scope => :user_id
end