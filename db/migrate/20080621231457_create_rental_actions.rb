class CreateRentalActions < ActiveRecord::Migration
  def self.up
    create_table :rental_actions do |t|
      t.string :name
      t.integer :contact_id
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :rental_actions
  end
end
