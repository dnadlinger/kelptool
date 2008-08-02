class AddItemCategoryPositioning < ActiveRecord::Migration
  def self.up
  	add_column( 'item_categories', 'position', :integer )
  	
  	# Reset the column information to be able to use the newly created position column
		# (http://noobonrails.blogspot.com/2007/02/actsaslist-makes-lists-drop-dead-easy.html)
  	ItemCategory.reset_column_information
  	
  	ItemCategory.find( :all ).each_with_index do | category, i |
  		# Start with position 1
  		category.position = i + 1
  		category.save!
  	end
  end

  def self.down
  	remove_column( 'item_categories', 'position' )
  end
end
