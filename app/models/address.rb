class Address < ActiveRecord::Base
	include Gmaps4rails::ActsAsGmappable
	acts_as_gmappable :process_geocoding => false
                      
	geocoded_by :address
	after_validation :geocode

	has_one :posts

	has_many :job_preferences


	def gmaps4rails_address
    	# "#{self.address}, #{self.city}"
    	return @address = self.street + ", " + self.city + ", " + self.country_code
  	end
  	def address
  		[street, city, country_code].compact.join(', ')
	end

	def self.location_search(params)
		if params[:addr] && params[:addr] != ''
			if params[:dist] && params[:dist] != ''
				Address.near(params[:addr], params[:dist])
			else 
				Address.near(params[:addr], 500)
			end	
		else
			return nil
		end
	end

end
