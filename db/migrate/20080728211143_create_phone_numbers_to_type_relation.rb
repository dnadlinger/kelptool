class CreatePhoneNumbersToTypeRelation < ActiveRecord::Migration
  def self.up
  	rename_column( :phone_numbers, :type, :phone_number_type_id )
  end

  def self.down
  	rename_column( :phone_numbers, :phone_number_type_id, :type )
  end
end
