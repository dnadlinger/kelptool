class ItemRental < ActiveRecord::Base
  belongs_to :item
  belongs_to :rental_action
  
  validates_numericality_of :quantity, :greater_than => 0, :message => 'Ungültige Anzahl (muss mindestens 1 sein).'
  
  named_scope :deactivated, :include => [ :rental_action ], :conditions => [ 'rental_actions.deactivated = ?', true ]
  named_scope :active, :include => [ :rental_action ], :conditions => [ 'rental_actions.deactivated = ?', false ]
  
  def price
    price_without_discount * self.rental_action.customer.price_factor
  end
  
  def price_without_discount
    self.item.price.get_price_for( self.rental_action.duration ) * self.quantity
  end
  
  def quantity_available
    self.item.num_available_for( self.rental_action )
  end
  
  def available?
    return self.quantity <= self.quantity_available
  end
  
  def event_date
    self.rental_action.start_date
  end
  
  def mark_as_handed_out!
    return false if self.handed_out?
    
    self.item.num_in_stock -= self.quantity;
    self.handed_out = true
    
    return false unless self.item.save!
    return false unless self.save!
    return true
  end
  
  def mark_as_returned!
    return false if self.returned?
    
    self.item.num_in_stock += self.quantity;
    self.returned = true
    
    return false unless self.item.save!
    return false unless self.save!
    return true
  end
  
  def reset_state!
    if self.handed_out?
      self.handed_out = false
      self.item.num_in_stock += self.quantity
    end
    
    if self.returned?
      self.returned = false
      self.item.num_in_stock -= self.quantity
    end
    
    return false unless self.item.save!
    return false unless self.save!
    return true
  end
end
