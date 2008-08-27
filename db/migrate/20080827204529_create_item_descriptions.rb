class CreateItemDescriptions < ActiveRecord::Migration
  def self.up
    create_table :item_descriptions do |t|
      t.text :text
      
      t.integer :item_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :item_description
  end
end
