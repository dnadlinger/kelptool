class RenamePhoneNumbersTypeColumn < ActiveRecord::Migration
  def self.up
    rename_column( :phone_numbers, :phone_number_type_id, :type_id )
  end

  def self.down
    rename_column( :phone_numbers, :type_id, :phone_number_type_id )
  end
end
