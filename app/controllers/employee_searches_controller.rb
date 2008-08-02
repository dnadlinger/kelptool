class EmployeeSearchesController < ApplicationController
	def new
		@search_model = EmployeeSearch.new
		if params[ :search_query ]
			@search_model.contact = ContactSearch.new( :name => params[ :search_query ] )
			unless params[ :advanced_search ]
				render :action => 'create'
			end
		end
		@search_model.contact ||= ContactSearch.new
		@search_model.skills = []
		# Just render the template.
	end
	
	def create
		@search_model = EmployeeSearch.new( params[ :employee_search ] )
		@search_model.contact = ContactSearch.new( params[ :contact_search ] )
		@search_model.skills = []
		if params[ :employee ]
			params[ :employee ][ :skills_attributes ].each do |attributes|
				@search_model.skills << Skill.find_by_name( attributes[ :name ] )
			end
		end
	end

  def auto_complete_for_contact_name
  	@employees = Employee.find( :all,
  		:include => :contact,
  		:conditions => [ 'LOWER(contacts.name) LIKE ?', '%' + params[ :search_query ].downcase + '%' ], 
      :order => 'contacts.name ASC',
      :limit => 10 )
  	
		@contacts = []
		@employees.each { |employee| @contacts << employee.contact }
	end
end
