class PostingPosition < ActiveRecord::Base

	belongs_to :position_type
	belongs_to :post

	attr_accessible :position_type_id, :post_id

	validates_uniqueness_of :post_id, :scope => :position_type_id
end
 