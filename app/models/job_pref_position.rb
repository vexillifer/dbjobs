class JobPrefPosition < ActiveRecord::Base


	belongs_to :position_type
	belongs_to :job_preference

	validates_uniqueness_of :job_preference_id, :scope => :position_type_id

end
