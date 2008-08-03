class EmployeesController < ApplicationController
  def index
  	@employees = Employee.find( :all )
  end

  def show
  	@employee = Employee.find( params[ :id ] )
  end

  def new
    end_choosing ChoosingMode::EmployeesChooseContactTemplate
    
  	@employee = Employee.new
    
  	begin
      @employee.contact = Contact.find( params[ :contact_id ] )
    rescue ActiveRecord::RecordNotFound
      @employee.contact = Contact.new
    end
    
  	unless params[ :skill_id ].nil?
  		@employee.skills << Skill.find( params[ :skill_id ] )
  	else
  		@employee.skills << Skill.new
    end
  end
  
  def create
  	@employee = Employee.new( params[ :employee ] )
  	
  	if @employee.save
			flash[ :notice ] = 'Mitarbeiter hinzugefügt.'
			redirect_to :action => 'index'
		else
			render :action => 'new'
		end
  end

  def edit
  	@employee = Employee.find( params[ :id ] )
	end
 
	def update
		params[ :employee ][ :contact_attributes ][ :existing_phone_numbers_attributes ] ||= {}
		
    @employee = Employee.find( params[ :id ] ) 
		if @employee.update_attributes( params[ :employee ] )
			flash[ :notice ] = 'Änderungen gespeichert.'
			redirect_to employee_path
		else
			render :action => 'edit'
		end
	end
	
	def choose_contact_template
    start_choosing ChoosingMode::EmployeesChooseContactTemplate
    redirect_to customers_url
	end
end
