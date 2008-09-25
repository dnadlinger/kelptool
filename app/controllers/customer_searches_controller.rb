class CustomerSearchesController < ApplicationController
  def new
    @search_model = CustomerSearch.new
    
    if params[ :search_query ]
      @search_model.contact = ContactSearch.new( :name => params[ :search_query ] )
      
      unless params[ :advanced_search ]
        if @search_model.customers.size == 1
          redirect_to @search_model.customers.first
        else
          render :action => 'create'
        end
      end
    end
    
    @search_model.contact ||= ContactSearch.new
  end
  
  def create
    @search_model = CustomerSearch.new( params[ :customer_search ] )
    @search_model.contact = ContactSearch.new( params[ :contact_search ] )
  end

  def auto_complete_for_contact_name
    customers = Customer.find( :all,
      :include => :contact,
      :conditions => [ 'LOWER(contacts.name) LIKE ?', '%' + params[ :search_query ].downcase + '%' ], 
      :order => 'contacts.name ASC',
      :limit => 10 )
    
    @contacts = customers.collect &:contact
    render :inline => '<%= auto_complete_result contacts, :name, query, 25 %>',
      :locals => { :contacts => @contacts, :query => params[ :search_query ] }
  end
end
