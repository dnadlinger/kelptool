class AddDeactivatedToRentalAction < ActiveRecord::Migration
  def self.up
    add_column :rental_actions, :deactivated, :boolean, :default => false
    RentalAction.reset_column_information
    RentalAction.all.each do |ra|
      ra.deactivated = false
      ra.save!
    end
  end

  def self.down
    remove_column :rental_actions, :deactivated
  end
end
