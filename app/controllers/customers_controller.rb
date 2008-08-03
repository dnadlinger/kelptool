class CustomersController < ApplicationController
  def index
  	@customers = Customer.find( :all )
  end
  
  def show
    @customer = Customer.find( params[ :id ] )
  end
  
  def new
    end_choosing ChoosingMode::CustomersChooseContactTemplate
    
    @customer = Customer.new
    @customer.discount = 1000
    
    begin
      @customer.contact = Contact.find( params[ :contact_id ] )
    rescue ActiveRecord::RecordNotFound
      @customer.contact = Contact.new
    end
  end
  
  def create
    @customer = Customer.new( params[ :customer ] )
    @customer.create_contact( params[ :contact ] )
    
    if @customer.save
    	flash[ :notice ] = 'Kunde angelegt.'
    	redirect_to :action => 'index'
    else
    	render :action => 'new'
    end
  end
  
  def edit
    @customer = Customer.find( params[ :id ] )
  end
  
  def update
    @customer = Customer.find( params[ :id ] ) 
    if @customer.contact.update_attributes( params[ :contact ] ) and @customer.update_attributes( params[ :customer ] )
    	flash[ :notice ] = 'Änderungen gespeichert.'
    	redirect_to customer_path( @customer )
    else
    	render :action => 'edit'
    end
  end
  
  def destroy
    @customer = Customer.find( params[ :id ] )
  end
 
  def choose_contact_template
    start_choosing ChoosingMode::CustomersChooseContactTemplate
    redirect_to employees_url
  end
end