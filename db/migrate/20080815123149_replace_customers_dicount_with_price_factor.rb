class ReplaceCustomersDicountWithPriceFactor < ActiveRecord::Migration
  def self.up
    add_column( 'customers', 'price_factor', :decimal )
    
    say_with_time 'Converting pricing information...' do
      Customer.reset_column_information
      Customer.all.each do |customer|
        customer.price_factor = customer.discount * 0.001
        customer.save!
      end
    end
    
    remove_column( 'customers', 'discount' )
  end

  def self.down
    add_column( 'customers', 'discount', :integer )
    
    say_with_time 'Converting pricing information...' do
      Customer.reset_column_information
      Customer.all.each do |customer|
        customer.discount = customer.price_factor * 1000
        customer.save!
      end
    end
    
    remove_column( 'customers', 'price_factor' )
  end
end
