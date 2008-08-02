module SearchConditions
	def prepare_conditions
	  [ conditions_clauses.join(' AND '), *conditions_options ]
	end
	
	def conditions_clauses
	  conditions_parts.map { |condition| condition.first }
	end
	
	def conditions_options
	  conditions_parts.map { |condition| condition[ 1..-1 ] }.flatten
	end
	
	def conditions_parts
	  condition_methods = protected_methods( false ).grep( /_conditions$/ )
	  if condition_methods.nil?
	  	return nil
	  else
	  	condition_methods.map { |m| send(m) }.compact
	  end 
	end
end