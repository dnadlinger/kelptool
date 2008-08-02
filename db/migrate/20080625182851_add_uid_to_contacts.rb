class AddUidToContacts < ActiveRecord::Migration
  def self.up
  	add_column( 'contacts', 'uid', :string )
  end

  def self.down
  	remove_column( 'contacts', 'uid' )
  end
end
