class RentalActionSearchesController < ApplicationController
  def new
    end_choosing ChoosingMode::RentalActionSearchesChooseCustomer
    
    @search_model = RentalActionSearch.new
    
    if params[ :search_query ]
      @search_model.name = params[ :search_query ]
      
      unless params[ :advanced_search ]
        render :action => 'create'
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
    @rental_actions = RentalAction.find( :all,
      :conditions => [ 'LOWER( name ) LIKE ?', '%' + params[ :search_query ].downcase + '%' ], 
      :order => 'name ASC',
      :limit => 10 )
  end
  
  def choose_customer
    start_choosing ChoosingMode::RentalActionSearchesChooseCustomer
    redirect_to customers_url
  end
end
