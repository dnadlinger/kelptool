class ItemRental < ActiveRecord::Base
  belongs_to :item
  belongs_to :rental_action
  
  validates_numericality_of :quantity, :greater_than => 0, :message => 'Ungültige Anzahl (muss mindestens 1 sein).'
  
  def price
    self.item.price.get_price_for( self.rental_action.duration ) * self.quantity
  end
  
  def mark_as_handed_out!
    return false if self.handed_out?
    
    self.item.num_in_stock -= 1;
    self.handed_out = true
    
    return false unless self.item.save!
    return false unless self.save!
    return true
  end
  
  def mark_as_returned!
    return false if self.returned?
    
    self.item.num_in_stock += 1;
    self.returned = true
    
    return false unless self.item.save!
    return false unless self.save!
    return true
  end
  
  def reset_state!
    if self.handed_out?
      self.handed_out = false
      self.item.num_in_stock += 1
    end
    
    if self.returned?
      self.returned = false
      self.item.num_in_stock -= 1
    end
    
    return false unless self.item.save!
    return false unless self.save!
    return true
  end
end
