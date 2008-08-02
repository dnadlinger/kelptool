class EmployeeSearch < ActiveRecord::BaseWithoutTable
	attr_accessor :contact, :skills, :comment
	
	def employees
		find_employees
	end
	
	protected
	
	include SearchConditions
	def find_employees
		unless skills.blank?
	  	Employee.with_skills( skills ).all( :conditions => prepare_conditions, :include => :contact )
	 	else
	 		Employee.all( :conditions => prepare_conditions, :include => :contact )
	 	end
	 	
	end
	
	def comment_conditions
	  [ "employees.comment LIKE ?", "%#{ comment }%" ] unless comment.blank?
	end
	
	def contact_conditions
		logger.debug contact.get_conditions.inspect
		contact.get_conditions unless contact.nil?
	end
end