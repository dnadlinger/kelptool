class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.text :comment
      t.integer :contact_id

      t.timestamps
    end
  end

  def self.down
    drop_table :employees
  end
end
