class ItemNotesController < ApplicationController
  before_filter :get_item, :except => [ :index ]
  
  def index
    flash.keep
    redirect_to item_category_item_url( params[ :item_category_id ], params[ :item_id ] )
  end
  
  def new
    @item_note = ItemNote.new
    @item_note.item = @item
  end
  
  def create
    @item_note = ItemNote.new( params[ :item_note ] )
    @item_note.item = @item
    
    if @item_note.save
      flash[ :notice ] = 'Notiz gespeichert.'
      redirect_to item_category_item_item_notes_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @item_note = ItemNote.find( params[ :id ] )
  end
  
  def update
    @item_note = ItemNote.find( params[ :id ] )
    
    if @item_note.update_attributes( params[ :item_note ] )
      flash[ :notice ] = 'Notiz gespeichert.'
      redirect_to item_category_item_item_notes_url
    else
      render :actin => 'edit'
    end
  end
  
  def destroy
    @item_note = ItemNote.find( params[ :id ] )
    @item_note.destroy
    flash[ :notice ] = 'Notiz gelöscht.'
    redirect_to item_category_item_item_notes_url
  end
  
  private
    def get_item
      @item = Item.find( params[ :item_id ] )
    end
end
