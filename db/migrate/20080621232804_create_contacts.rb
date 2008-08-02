class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :name
      t.string :adress
      t.string :place
      t.string :email
      t.text :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
