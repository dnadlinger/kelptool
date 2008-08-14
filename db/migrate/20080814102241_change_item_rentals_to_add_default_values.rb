class ChangeItemRentalsToAddDefaultValues < ActiveRecord::Migration
  def self.up
    change_column_default :item_rentals, :handed_out, false
    change_column_default :item_rentals, :returned, false
    
    ItemRental.all.each do |item_rental|
      item_rental.handed_out = false if item_rental.handed_out.nil?
      item_rental.returned = false if item_rental.returned.nil?
      item_rental.save!
    end
  end

  def self.down
    change_column_default :item_rentals, :handed_out, nil
    change_column_default :item_rentals, :returned, nil
  end
end
