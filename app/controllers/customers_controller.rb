class CustomersController < ApplicationController
	before_filter :get_customer, :except => [ :index, :new, :create ]
	
	def index
		@customers = Customer.find( :all )
	end
	
	def show
		# Filters do the work.
	end
	
	def new
		@customer = Customer.new
		@customer.contact = Contact.new
		@customer.discount = 1000
	end
	
	def create
		@customer = Customer.new( params[ :customer ] )
		@customer.create_contact( params[ :contact ] )
		
		if @customer.save
			flash[ :notice ] = 'Kunde angelegt.'
			redirect_to :action => 'index'
		else
			render :action => 'new'
		end
	end
	
	def edit
		# Filters do the work.
	end
	
	def update
		if @customer.contact.update_attributes( params[ :contact ] ) and @customer.update_attributes( params[ :customer ] )
			flash[ :notice ] = 'Änderungen gespeichert.'
			redirect_to customer_path( @customer )
		else
			render :action => 'edit'
		end
	end
	
	def destroy
		
	end
	
	protected
	def get_customer
		@customer = Customer.find( params[ :id ] )
	end
end