class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name, :null => false
      t.string :manufacturer
      t.integer :total_count
      t.integer :num_in_stock

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
