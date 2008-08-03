class ChangeRentalRelationToCustomer < ActiveRecord::Migration
  def self.up
    remove_column( 'rental_actions', 'contact_id' ) 
    add_column( 'rental_actions', 'customer_id', :integer )
  end

  def self.down
    remove_column( 'rental_actions', 'customer_id' )
    add_column( 'rental_actions', 'contact_id', :integer )
  end
end
