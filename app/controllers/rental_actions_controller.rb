class RentalActionsController < ApplicationController
  def index
    @rental_actions = RentalAction.find( :all, :order => 'start_date' )
  end
  
  def show
    end_choosing ChoosingMode::RentalActionsChooseCustomer
    
    @rental_action = RentalAction.find( params[ :id ] )
    session[ :current_rental_action ] = @rental_action.id
  end
  
  def new
    end_choosing ChoosingMode::RentalActionsChooseTemplate
    
    unless params[ :template_id ].nil?
      @template_action = RentalAction.find( params[ :template_id ] )  
    end
    
    @rental_action = RentalAction.new
  end
  
  def create
    @rental_action = RentalAction.new( params[ :rental_action ] )
    
    unless params[ :template_action_id ].nil?
      template_action = RentalAction.find( params[ :template_action_id ] )
      @rental_action.customer = template_action.customer
      template_action.item_rentals.each do |item_rental|
        @rental_action.item_rentals << item_rental.clone
      end
    end
    
    if @rental_action.save
      flash[ :notice ] = 'Mietvorgang angelegt. Sie können jetzt die Details bearbeiten.'
      redirect_to rental_action_url( @rental_action )
    else
      render :action => 'new'
    end
  end
  
  def edit
    @rental_action = RentalAction.find( params[ :id ] )
  end
  
  def update
    @rental_action = RentalAction.find( params[ :id ] )
    
    if @rental_action.update_attributes( params[ :rental_action ] )
      flash[ :notice ] = ''
      redirect_to rental_action_url( @rental_action )
    else
      render :action => 'edit'
    end
  end
  
  def deactivate
    @rental_action = RentalAction.find( params[ :id ] )
    
    unless @rental_action.deactivated
      @rental_action.deactivated = true
      @rental_action.save!
    else
      flash[ :error ] = 'Der Mietvorgang ist bereits deaktiviert.'
    end
    
    redirect_to rental_action_url
  end
  
  def activate
    @rental_action = RentalAction.find( params[ :id ] )
    
    if @rental_action.deactivated
      @rental_action.deactivated = false
      @rental_action.save!
    else
      flash[ :error ] = 'Der Mietvorgang ist bereits aktiviert.'
    end
    
    redirect_to rental_action_url
  end  
  
  def choose_customer
    @rental_action = RentalAction.find( params[ :id ] )
    start_choosing ChoosingMode::RentalActionsChooseCustomer, @rental_action
    redirect_to customers_url
  end
  
  def set_customer
    @rental_action = RentalAction.find( params[ :id ] )
    @rental_action.customer = Customer.find( params[ :customer_id ] )
    @rental_action.save
    
    session[ :choosing_mode ] = nil
    flash[ :notice ] = 'Kundeninformation aktualisiert.'
    redirect_to :action => 'show'
  end

  def choose_template
    start_choosing ChoosingMode::RentalActionsChooseTemplate
    redirect_to rental_actions_url
  end
end
