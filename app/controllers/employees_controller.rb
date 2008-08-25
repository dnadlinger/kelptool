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
      redirect_to @employee
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @employee = Employee.find( params[ :id] )
    @employee.destroy
    flash[ :notice ] = 'Mitarbeiter gelöscht.'
    redirect_to employees_url
  end
  
  def choose_contact_template
    start_choosing ChoosingMode::EmployeesChooseContactTemplate
    redirect_to customers_url
  end
  
  def detach_contact
    @employee = Employee.find( params[ :id ] )
    
    if @employee.contact.customer
      @employee.contact = @employee.contact.clone
      @employee.save!
      
      flash[ :notice ] = 'Die Kontaktinformationen sind jetzt nicht mehr mit dem gleichnamigen Kunden verbunden.'
    else
      flash[ :error ] = 'Die Kontaktinformationen sind bereits getrennt.'
    end
    
    redirect_to edit_employee_url
  end
end
