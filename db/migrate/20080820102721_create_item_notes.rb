class CreateItemNotes < ActiveRecord::Migration
  def self.up
    create_table :item_notes do |t|
      t.text :content
      t.integer :item_id

      t.timestamps
    end
  end

  def self.down
    drop_table :item_notes
  end
end
