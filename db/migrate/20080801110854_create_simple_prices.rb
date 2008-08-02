class CreateSimplePrices < ActiveRecord::Migration
  def self.up
    create_table :simple_prices do |t|
      t.decimal :daily_rate

      t.timestamps
    end
  end

  def self.down
    drop_table :simple_prices
  end
end
