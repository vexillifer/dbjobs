class JobPreference < ActiveRecord::Base


  belongs_to :education_level, :foreign_key => :educatiion_level
  accepts_nested_attributes_for :education_level, :allow_destroy => true


  belongs_to :user

  has_many :job_pref_positions, :dependent => :destroy
  has_many :job_preferences, :through => :job_pref_positions



   def education_level=(value)
   		write_attribute(:education_level, value)
 	end

 	def education_level
   		read_attribute(:education_level)
 	end
end
