class RentalActionSearchesController < ApplicationController
  def new
    end_choosing ChoosingMode::RentalActionSearchesChooseCustomer
    
    @search_model = RentalActionSearch.new
    query = prepare_auto_completion_query( params[ :search_query ] )
    
    if query
      @search_model.name = query
      
      unless params[ :advanced_search ]
        if @search_model.rental_actions.size == 1
          redirect_to @search_model.rental_actions.first
        else
          render :action => 'create'
        end
      end
    end
    
    if params[ :customer_id ] 
      begin
        @search_model.customer = Customer.find( params[ :customer_id ] )
      rescue ActiveRecord::RecordNotFound
        @search_model.customer = nil
      end
    end
  end
  
  def create
    @search_model = RentalActionSearch.new( params[ :rental_action_search ] )
  end

  def auto_complete_for_rental_action_name
    query = params[ :search_query ]
    
    rental_actions = RentalAction.find( :all,
      :conditions => [ 'LOWER( name ) LIKE ?', '%' + query.downcase + '%' ], 
      :order => 'name ASC',
      :limit => 10 )
     
    render :inline => '<%= auto_complete_result rental_actions, :name, query, 25 %>',
      :locals => { :rental_actions => rental_actions, :query => query }
  end
  
  def choose_customer
    start_choosing ChoosingMode::RentalActionSearchesChooseCustomer
    redirect_to customers_url
  end
end
