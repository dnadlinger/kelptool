class AddPriceRelationToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :price_id, :integer
    add_column :items, :price_type, :string
  end

  def self.down
    remove_column :items, :price_id
    remove_column :items, :price_type
  end
end
