class ItemsController < ApplicationController
  before_filter :get_item_category, :except => [ :index, :update ]
  
  def index
    flash.keep
    redirect_to item_category_url( params[ :item_category_id ] )
  end
  
  def show
    @item = @category.items.find( params[ :id ] )
  end
  
  def new
    @item = Item.new
    @item.item_category = ItemCategory.find( params[ :item_category_id ] )
    @item.price = SimplePrice.new
  end
 
  def create
    @item = Item.new( params[ :item ] )
    @item.price = SimplePrice.new( params[ :simple_price ] )
    @item.num_in_stock = @item.total_count
    
    if @item.save
      flash[ :notice ] = 'Gerät hinzugefügt.'
      redirect_to item_category_item_url( @item.item_category_id, @item )
    else
      render :action => 'new'
    end
  end

  def edit
    @item = @category.items.find( params[ :id ] )
    @categories = ItemCategory.find( :all )
  end
  
  def update
    # The category stored in the params could be different from the one in the database
    # (if the item has been moved).
    
    @item = Item.find( params[ :id ] )
    if @item.update_attributes( params[ :item ] ) && @item.price.update_attributes( params[ :simple_price ] )
      flash[ :notice ] = 'Änderungen gespeichert.'
      redirect_to item_category_item_url( @item.item_category_id, @item )
    else
      @categories = ItemCategory.find( :all )
      render :action => 'edit'
    end
  end
  
  def destroy
    @item = @category.items.find( params[ :id ] )
    if @item.rental_actions.count > 0
      flash[ :error ] = 'Das Gerät wurde bereits vermietet und kann deswegen nicht mehr gelöscht werden!'
      redirect_to item_category_items_url( @category )
    else
      @item.destroy
      flash[ :notice ] = 'Gerät gelöscht.'
      redirect_to item_categories_url
    end
  end
  
  protected
  def get_item_category
    @category = ItemCategory.find( params[ :item_category_id ] )
  end
end