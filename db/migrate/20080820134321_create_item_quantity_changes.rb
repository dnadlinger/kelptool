class CreateItemQuantityChanges < ActiveRecord::Migration
  def self.up
    create_table :item_quantity_changes do |t|
      t.integer :amount
      t.text :reason
      t.integer :item_id

      t.timestamps
    end
  end

  def self.down
    drop_table :item_quantity_changes
  end
end
