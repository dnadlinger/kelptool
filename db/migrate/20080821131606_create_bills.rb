class CreateBills < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      t.integer :serial_number
      t.string :type_key
      t.integer :rental_action_id
      
      t.string :filename
      t.string :content_type      
      t.integer :size
      t.integer :db_file_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :bills
  end
end
