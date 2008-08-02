class AddPostcodeToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :postcode, :string
  end

  def self.down
    remove_column :contacts, :postcode
  end
end
