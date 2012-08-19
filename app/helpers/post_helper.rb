module PostHelper

	def get_status(value)
  		if value == 0
  			"Pending"
  		elsif value == 1
  			"Active"
  		elsif value == 2
  			"Expired"
  		elsif value == 3
  			"Rejected"
  		end
  	end

  
end
