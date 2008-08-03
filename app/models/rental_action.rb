class RentalAction < ActiveRecord::Base
  belongs_to :customer
  
  has_many :item_rentals, :dependent => :destroy
  has_many :items, :through => :item_rentals
  
  validates_presence_of :name, :message => 'Bitte geben Sie einen Namen für die Mietaktion (z. B. den Namen der Verantstaltung) ein.'
  validates_presence_of :start_date, :message => 'Bitte wählen Sie das Datum aus, an dem die Aktion beginnen soll.'
  validates_presence_of :end_date, :message => 'Bitte wählen Sie das Datum aus, an dem die Aktion enden soll.'
  
  def start_date
    self.attributes[ 'start_date' ].to_time if attributes[ 'start_date' ]
  end
  
  def end_date
    self.attributes[ 'end_date' ].to_time if attributes[ 'end_date' ]
  end
  
  
  def duration
    self.end_date - self.start_date
  end
  
  def duration_formatted
    string = ( duration.to_f / 1.day.to_f ).ceil.to_s
    string += ' Tag'
    string += 'e' if duration > 1.day
    return string
 end
 
 
  def overall_price
    sum = 0
    self.item_rentals.each do |item_rental|
      sum += item_rental.price
    end
    return sum
  end
end
