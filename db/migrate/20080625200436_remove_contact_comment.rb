class RemoveContactComment < ActiveRecord::Migration
  def self.up
  	remove_column( 'contacts', 'comments' )
  end

  def self.down
  	add_column( 'contacts', 'comments', :text )
  end
end
