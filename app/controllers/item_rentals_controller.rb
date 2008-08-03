class ItemRentalsController < ApplicationController
  before_filter :get_rental_action
  
  def index
  	@item_rentals = @rental_action.item_rentals
  end
  
  def show
  
  end
  
  def choose_item
    start_choosing ChoosingMode::ItemRentalsChooseItem, @rental_action
    redirect_to item_categories_url
  end  
  
  def new
  	end_choosing ChoosingMode::ItemRentalsChooseItem
  	
  	@item_rental = ItemRental.new
  	@item_rental.item = Item.find( params[ :item_id ] )
  	@item_rental.rental_action = @rental_action
  end
  
  def create
  	@item_rental = ItemRental.new( params[ :item_rental ] )
  	
  	if @item_rental.save
  		flash[ :notice ] = 'Gerät hinzugefügt.'
  		redirect_to rental_action_item_rentals_url
  	else
  		render :action => 'new'
  	end
  end
	
	def edit
    @item_rental = ItemRental.find( params[ :id ] )
    respond_to do |format|
      format.html do
        @item_rentals = @rental_action.item_rentals
        # Because @item_rental is set, the index view will display the correct
        # item rental in editing mode.
        render :action => 'index'
      end
      format.js
    end
	end
	
  def update
    @item_rental = ItemRental.find( params[ :id ] )
    if @item_rental.update_attributes( params[ :item_rental ] )
      respond_to do |format|
        format.html do
          redirect_to rental_action_item_rentals_url
        end
        format.js
      end
    else
      redirect_to edit_rental_action_item_rental_url
    end
  end
	
	def destroy
		@item_rental = ItemRental.find( params[ :id ] )
    @item_rental.destroy
    flash[ :notice ] = 'Gerät aus der Liste entfernt.'
    redirect_to rental_action_item_rentals_url
	end
	
	def handed_out
		@item_rental = ItemRental.find( params[ :id ] )
		
		unless @item_rental.handed_out?
			mark_as_handed_out( @item_rental )
		else
			flash[ :error ] = 'Der Gegenstand wurde bereits als ausgegeben gekennzeichnet.'
		end
		
		flash[ :notice ] = 'Das Gerät wurde als ausgegeben gekennzeichnet.'
		redirect_to rental_action_item_rentals_url
	end
	
	def all_handed_out
		@rental_action.item_rentals.reject( &:handed_out? ).each do |item_rental|
			mark_as_handed_out( item_rental )
		end
		
		flash[ :notice ] = 'Alle Geräte wurden als ausgegeben gekennzeichnet.'
		redirect_to rental_action_item_rentals_url
	end
	
	def returned
		@item_rental = ItemRental.find( params[ :id ] )
		
		unless @item_rental.returned?
			mark_as_returned( @item_rental )
		else
			flash[ :error ] = 'Der Gegenstand wurde bereits als zurückgebracht gekennzeichnet.'
		end
		
		flash[ :notice ] = 'Das Gerät wurde als zurückgebracht gekennzeichnet.'
		redirect_to rental_action_item_rentals_url
	end
	
	def all_returned
		@rental_action.item_rentals.reject( &:returned? ).each do |item_rental|
			mark_as_returned( item_rental )
		end
		
		flash[ :notice ] = 'Alle Geräte wurden als zurückgebracht gekennzeichnet.'
		redirect_to rental_action_item_rentals_url
	end
	
	def reset_state
		@item_rental = ItemRental.find( params[ :id ] )
		
		reset_state_for( @item_rental )
		
		flash[ :notice ] = 'Der Zustand des Gerätes wurde zurückgesetzt.'
		redirect_to rental_action_item_rentals_url
	end
	
	
	protected
	
	def get_rental_action
		@rental_action = RentalAction.find( params[ :rental_action_id ] )
	end
	
	def mark_as_handed_out( item_rental )
		item_rental.item.num_in_stock -= 1;
		item_rental.handed_out = true
		item_rental.item.save!
		item_rental.save!
	end
	
	def mark_as_returned( item_rental )
		item_rental.item.num_in_stock += 1;
		item_rental.returned = true
		item_rental.item.save!
		item_rental.save!
	end
	
	def reset_state_for( item_rental )
		if item_rental.handed_out?
			item_rental.handed_out = false
			item_rental.item.num_in_stock += 1
		end
		
		if item_rental.returned?
			item_rental.returned = false
			item_rental.item.num_in_stock -= 1
		end
		
		item_rental.item.save!
		item_rental.save!
	end
end
