class MergeItemManufacturerAndName < ActiveRecord::Migration
  def self.up
    for item in Item.all
      item.name = item.manufacturer + ' ' + item.name
      item.save!
    end
    remove_column :items, :manufacturer
  end

  def self.down
    add_column :items, :manufacturer, :string
  end
end
