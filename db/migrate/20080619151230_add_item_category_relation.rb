class AddItemCategoryRelation < ActiveRecord::Migration
  def self.up
    add_column( 'items', 'item_category_id', :integer, :null => false, :default => 1 )
    Item.update_all( 'item_category_id = 1' )
  end

  def self.down
    remove_column( 'items', 'item_category_id' )
  end
end
