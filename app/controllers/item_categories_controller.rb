class ItemCategoriesController < ApplicationController
  def index
    @categories = ItemCategory.find( :all, :order => 'position' )
  end

  def show
    @category = ItemCategory.find( params[ :id ] )
    respond_to do |format|
      format.html do
        @categories = ItemCategory.find( :all, :order => 'position' )  
        # Because the @category is set, the category's items will be displayed by the index view. 
        render :action => 'index'
      end
      format.js
    end
  end
  
  def new
    @category = ItemCategory.new
  end
  
  def create
    @category = ItemCategory.new( params[ :item_category ] )
    
    if @category.save
      flash[ :notice ] = 'Kategorie hinzugefügt.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @category = ItemCategory.find( params[ :id ] )
  end
  
  def update
    @category = ItemCategory.find( params[ :id ] ) 
    if @category.update_attributes( params[ :item_category ] )
      flash[ :notice ] = 'Änderungen gespeichert.'
      redirect_to :action => 'show'
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @category = ItemCategory.find( params[ :id ] ) 
    unless @category.empty?
      flash[ :error ] = 'Kategorien können nur gelöscht werden, wenn sie leer sind!'
      redirect_to :action => 'show'
    else
      @category.destroy
      flash[ :notice ] = 'Kategorie gelöscht.'
      redirect_to :action => 'index'
    end
  end
  
  def move_up
    ItemCategory.find( params[ :id ] ).move_higher
    redirect_to :action => 'index'
  end
  
  def move_down
    ItemCategory.find( params[ :id ] ).move_lower
    redirect_to :action => 'index'
  end

  def auto_complete_for_item_name
    @items = Item.find( :all,
      :conditions => [ 'LOWER(name) LIKE ?', '%' + params[ :search_query ].downcase + '%' ], 
      :order => 'name ASC',
      :limit => 10
    )
    
    render :inline => '<%= auto_complete_result items, :name, query, 25 %>',
      :locals => { :items => @items, :query => params[ :search_query ] }
  end
  
  def search
    @search_results = Item.search( params[ :search_query ] )
    
    if @search_results.size == 1
      if choosing_mode_active?( ChoosingMode::ItemRentalsChooseItem )
        redirect_to build_choose_path( current_choosing_mode, @search_results.first )
      else
        redirect_to @search_results.first
      end
    end
  end
end
