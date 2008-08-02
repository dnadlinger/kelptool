class CreateItemRentals < ActiveRecord::Migration
  def self.up
    create_table :item_rentals do |t|
      t.integer :item_id
      t.integer :rental_action_id
      t.integer :quantity
      t.boolean :handed_out
      t.boolean :returned

      t.timestamps
    end
  end

  def self.down
    drop_table :item_rentals
  end
end
