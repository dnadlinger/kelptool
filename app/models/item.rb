class Item < ActiveRecord::Base
  belongs_to :item_category
  
  has_many :item_rentals, :dependent => :destroy
  has_many :rental_actions, :through => :item_rentals
  
  has_many :item_notes, :dependent => :destroy
  has_many :item_quantity_changes, :dependent => :destroy
  
  belongs_to :price, :polymorphic => true
  
  validates_associated :price, :message => 'Preis ist ungültig.'
    
  validates_presence_of :name, :message => 'Bitte geben Sie einen Namen für das Gerät ein.'
  validates_uniqueness_of :name, :message => 'Der Name muss eindeutig sein.'
  
  validates_presence_of :item_category_id, :message => 'Das Gerät muss einer Kategorie angehören.'
  
  validates_numericality_of :total_count, :only_integer => true, :message => 'Keine gültige Gesamtanzahl.'
  # We don't need to validate the number of the items in stock since the user can't mess around with it anyway.
  
  
  def self.search( query )
    unless query.blank?
      find( :all, :conditions => [ 'name LIKE ?', '%' + query + '%' ])
    else
      all
    end
  end
  
  
  def full_name
    return name
  end
  
  def events
    result = []
    result.concat( item_rentals.active )
    result.concat( item_notes )
    result.concat( item_quantity_changes )
    
    # Sort on event_date DESC.
    result.sort! do |a, b|
      b.event_date <=> a.event_date
    end
    
    return result
  end
  
  def revenue_overall
    sum = 0
    
    self.item_rentals.each do |ir|
      sum += ir.price
    end
    
    return sum
  end
  
  def revenue_per_piece
    revenue_overall.to_f / self.total_count.to_f
  end
  
  def rentals_overall
    self.item_rentals.sum( :quantity )
  end
  
  def rentals_per_piece
    rentals_overall.to_f / self.total_count.to_f
  end
  
  def num_available_between( start_date, end_date, exclude_rental_actions = nil )
    if exclude_rental_actions
      exclude_rental_actions = [ exclude_rental_actions ] if exclude_rental_actions.class == RentalAction
      rental_action_ids = exclude_rental_actions.collect( &:id )
      exclude_condition = " AND rental_actions.id NOT IN( #{ rental_action_ids.join( ', ' ) } )"
    else
      exclude_condition = ''
    end
    
    available = self.num_in_stock
    
    # The "|| 0"-clause on this and the following sum call should not be needed.
    # But due to a bug in Rails 2.1.0, which is already fixed in edge, calling
    # sum on an association returns nil instead of 0.
    available += self.item_rentals.active.sum(
      :quantity,
      :include => [ :rental_action ],
      :conditions => [
        'handed_out = ? AND returned = ? AND rental_actions.end_date < ?' + exclude_condition,
        true, false, start_date
      ]
    ) || 0
    
    if ( available > self.total_count )
      available = total_count
      # TODO: Generate warning message for user?
      logger.warn( "After counting non-returned ItemRentals, the number of available items (id: #{self.id}) is bigger than the total_count." )
    end
    
    available -= self.item_rentals.active.sum(
      :quantity,
      :include => [ :rental_action ],
      :conditions => [
        'handed_out = ? AND rental_actions.start_date <= ? AND rental_actions.end_date >= ?' + exclude_condition,
        false, end_date, start_date
      ]
    ) || 0
    
    if ( available < 0 )
      available = 0
      # TODO: Generate warning message for user?
      logger.warn( "After counting overlapping ItemRentals, the number of available items (id: #{self.id}) is below zero." )
    end
    
    return available
  end
  
  def num_available_for( rental_action )
    num_available_between( rental_action.start_date, rental_action.end_date, rental_action )
  end
end
