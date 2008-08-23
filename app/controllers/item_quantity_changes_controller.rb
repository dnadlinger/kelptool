class ItemQuantityChangesController < ApplicationController
  before_filter :get_item, :except => [ :index ]
  
  def index
    flash.keep
    redirect_to item_category_item_url( params[ :item_category_id ], params[ :item_id ] )
  end

  def new
    @item_quantity_change = ItemQuantityChange.new
    @item_quantity_change.item = @item
  end

  def create
    @item_quantity_change = ItemQuantityChange.new( params[ :item_quantity_change ] )
    @item_quantity_change.item = @item
    
    if @item_quantity_change.save
      flash[ :notice ] = 'Bestandsänderung registiert.'
      redirect_to item_category_item_item_quantity_changes_url
    else
      render :action => 'new'
    end
  end

  def edit
    @item_quantity_change = ItemQuantityChange.find( params[ :id ] )
  end

  def update
    @item_quantity_change = ItemQuantityChange.find( params[ :id ] )
    
    if @item_quantity_change.update_attributes( params[ :item_quantity_change ] )
      flash[ :notice ] = 'Änderung gespeichert.'
      redirect_to item_category_item_item_quantity_changes_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @item_quantity_change = ItemQuantityChange.find( params[ :id ] )
    @item_quantity_change.destroy
    flash[ :notice ] = 'Bestandsänderung gelöscht.'
    redirect_to item_category_item_item_quantity_changes_url
  end

  private
    def get_item
      @item = Item.find( params[ :item_id ] )
    end
end
