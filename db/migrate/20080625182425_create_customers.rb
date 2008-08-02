class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.integer :discount
      t.text :comment
      t.integer :contact_id

      t.timestamps
    end
  end

  def self.down
    drop_table :customers
  end
end
