class CreatePhoneNumbers < ActiveRecord::Migration
  def self.up
    create_table :phone_numbers do |t|
      t.string :number
      t.integer :type
      t.integer :contact_id

      t.timestamps
    end
  end

  def self.down
    drop_table :phone_numbers
  end
end
