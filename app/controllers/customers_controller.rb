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
    @customer.price_factor = 1
    
    begin
      @customer.contact = Contact.find( params[ :contact_id ] )
    rescue ActiveRecord::RecordNotFound
      @customer.contact = Contact.new
    end
  end
  
  def create
    @customer = Customer.new( params[ :customer ] )
    
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
    if @customer.update_attributes( params[ :customer ] )
      flash[ :notice ] = 'Änderungen gespeichert.'
      redirect_to :action => 'show'
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @customer = Customer.find( params[ :id ] )
    unless @customer.rental_actions.empty?
      flash[ :error ] = 'Diesem Kunden wurden schon Mietaktionen zugeordnet. Er kann daher nicht mehr gelöscht werden.'
      redirect_to :action => 'show'
    else
      @customer.destroy
      flash[ :notice ] = 'Kunde gelöscht.'
      redirect_to :action => 'index'
    end
  end
 
  def choose_contact_template
    start_choosing ChoosingMode::CustomersChooseContactTemplate
    redirect_to employees_url
  end
  
  def detach_contact
    @customer = Customer.find( params[ :id ] )
    
    if @customer.contact.employee
      @customer.contact = @customer.contact.clone
      @customer.save!
      
      flash[ :notice ] = 'Kontaktinformationen werden nicht mehr mit dem gleichnamigen Mitarbeiter geteilt.'
    else
      flash[ :error ] = 'Die Kontaktinformationen sind bereits getrennt.'
    end
    
    redirect_to :action => 'edit'
  end
  
end
