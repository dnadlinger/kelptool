class RentalActionsController < ApplicationController
  before_filter :get_rental_action, :except => [ :index, :new, :create, :choose_template ]
  
  def index
    @rental_actions = RentalAction.find( :all, :order => 'start_date' )
  end
  
  def show
    end_choosing ChoosingMode::RentalActionsChooseCustomer
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
    # Filters do the work.    
  end
  
  def update
    if @rental_action.update_attributes( params[ :rental_action ] )
      flash[ :notice ] = ''
      redirect_to rental_action_url( @rental_action )
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    
  end
  
  def choose_customer
    start_choosing ChoosingMode::RentalActionsChooseCustomer, @rental_action
    redirect_to customers_url
  end
  
  def set_customer
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
  
  protected
  def get_rental_action
    @rental_action = RentalAction.find( params[ :id ] )
  end
end
