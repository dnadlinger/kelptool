class RentalAction < ActiveRecord::Base
  belongs_to :customer
  
  has_many :item_rentals, :dependent => :destroy
  has_many :items, :through => :item_rentals
  
  has_many :bills
  
  
  validates_presence_of :name, :message => 'Bitte geben Sie einen Namen für die Mietaktion (z. B. den Namen der Verantstaltung) ein.'
  validates_presence_of :start_date, :message => 'Bitte wählen Sie das Datum aus, an dem die Aktion beginnen soll.'
  validates_presence_of :end_date, :message => 'Bitte wählen Sie das Datum aus, an dem die Aktion enden soll.'
  
  
  named_scope :deactivated, :conditions => { :deactivated => true }
  named_scope :active, :conditions => { :deactivated => false }  
  
  def start_date
    self.attributes[ 'start_date' ].to_time if attributes[ 'start_date' ]
  end
  
  def end_date
    self.attributes[ 'end_date' ].to_time if attributes[ 'end_date' ]
  end
  
  
  def duration
    self.end_date - self.start_date
  end
   
  def overall_price
    @overall_price ||= calculate_overall_price
  end
  
  def overall_price_without_discount
    @overall_price_without_discount ||= calculate_overall_price_without_discount
  end
  
  def overall_discount
    overall_price_without_discount - overall_price
  end
  
  
  protected
  
  def calculate_overall_price
    sum = 0
    self.item_rentals.each do |item_rental|
      sum += item_rental.price
    end
    return sum
  end
  
  def calculate_overall_price_without_discount
    sum = 0
    self.item_rentals.each do |item_rental|
      sum += item_rental.price_without_discount
    end
    return sum
  end
end
