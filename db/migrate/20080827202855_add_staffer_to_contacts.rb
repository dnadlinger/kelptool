class AddStafferToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :staffer, :string
  end

  def self.down
    remove_column :contacts, :staffer
  end
end
