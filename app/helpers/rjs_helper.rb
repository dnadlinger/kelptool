module RjsHelper
	def appear_duration_for( array )
		duration = 0.25
		unless array.empty? 
			duration *= array.count
		end
		return duration
	end
end