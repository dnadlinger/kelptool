class CreatePhoneNumberTypes < ActiveRecord::Migration
  def self.up
    create_table :phone_number_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :phone_number_types
  end
end
