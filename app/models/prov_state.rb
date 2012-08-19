class ProvState < ActiveRecord::Base
	has_one :country

	attr_accessible :prov_state
end
