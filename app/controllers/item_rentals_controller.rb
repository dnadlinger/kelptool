class ItemRentalsController < ApplicationController
  before_filter :get_rental_action
  
  def index
    @item_rentals = @rental_action.item_rentals
  end
  
  def choose_item
    start_choosing ChoosingMode::ItemRentalsChooseItem, @rental_action
    redirect_to item_categories_url
  end  
  
  def new
    end_choosing ChoosingMode::ItemRentalsChooseItem
    
    item = Item.find( params[ :item_id ] )
    existing_item_rental = @rental_action.item_rentals.detect { |ir| ir.item == item }
    
    if existing_item_rental
      flash[ :notice ] = 'Dieses Gerät ist bereits Teil der Mietaktion. Bitte bearbeiten Sie stattdessen die Anzahl.'
      redirect_to edit_rental_action_item_rental_url( @rental_action, existing_item_rental )
    else
      @item_rental = ItemRental.new
      @item_rental.item = item
      @item_rental.rental_action = @rental_action
    end
  end
  
  def create
    @item_rental = ItemRental.new( params[ :item_rental ] )
    
    if @item_rental.save
      flash[ :notice ] = 'Gerät zur Liste hinzugefügt.'
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
    
    if @item_rental.mark_as_handed_out!
      flash[ :notice ] = 'Gerät als ausgegeben gekennzeichnet.'
    else
      flash[ :error ] = 'Das Gerät war bereits als ausgegeben gekennzeichnet.'
    end
    
    redirect_to rental_action_item_rentals_url
  end
  
  def all_handed_out
    @rental_action.item_rentals.reject( &:handed_out? ).each do |item_rental|
      item_rental.mark_as_handed_out!
    end
    
    flash[ :notice ] = 'Alle Geräte als ausgegeben gekennzeichnet.'
    redirect_to rental_action_item_rentals_url
  end
  
  def returned
    @item_rental = ItemRental.find( params[ :id ] )
    
    if @item_rental.mark_as_returned!
      flash[ :notice ] = 'Gerät als zurückgebracht gekennzeichnet.'  
    else
      flash[ :error ] = 'Das Gerät war bereits als zurückgebracht gekennzeichnet.'
    end
    
    redirect_to rental_action_item_rentals_url
  end
  
  def all_returned
    @rental_action.item_rentals.reject( &:returned? ).each do |item_rental|
      item_rental.mark_as_returned!
    end
    
    flash[ :notice ] = 'Alle Geräte als zurückgebracht gekennzeichnet.'
    redirect_to rental_action_item_rentals_url
  end
  
  def reset_state
    @item_rental = ItemRental.find( params[ :id ] )
    
    @item_rental.reset_state!
    
    flash[ :notice ] = 'Zustand des Gerätes zurückgesetzt.'
    redirect_to rental_action_item_rentals_url
  end
  
  
  private
    def get_rental_action
      @rental_action = RentalAction.find( params[ :rental_action_id ] )
    end
end
