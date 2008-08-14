class Item < ActiveRecord::Base
  belongs_to :item_category
  
  has_many :item_rentals, :dependent => :destroy
  has_many :rental_actions, :through => :item_rentals
  
  belongs_to :price, :polymorphic => true
  
  validates_associated :price, :message => 'Preis ist ungültig.'
    
  validates_presence_of :name, :message => 'Der Name darf nicht leer sein.'
  validates_uniqueness_of :name, :message => 'Der Name muss eindeutig sein.'
  
  validates_presence_of :item_category_id, :message => 'Das Gerät muss einer Kategorie angehören.'
  
  validates_numericality_of :total_count, :only_integer => true, :message => 'Keine gültige Gesamtanzahl.'
  # We don't need to validate the number of the items in stock since the user can't mess around with it anyway.
  #validates_numericality_of :num_in_stock, :only_integer => true, :message => "Keine gültige Lagernd-Anzahl."
  
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
  
  def num_available_between( start_date, end_date, exclude_rental_actions = nil )
    if exclude_rental_actions
      exclude_rental_actions = [ exclude_rental_actions ] if exclude_rental_actions.class == RentalAction
      rental_action_ids = exclude_rental_actions.collect( &:id )
      exclude_condition = " AND rental_actions.id NOT IN( #{ rental_action_ids.join( ', ' ) } )"
    else
      exclude_condition = ''
    end
    
    available = self.num_in_stock
    logger.debug( available )
    available += ItemRental.sum(
      :quantity,
      :include => [ :rental_action ],
      :conditions => [
        'handed_out = ? AND returned = ? AND item_id = ? AND rental_actions.end_date < ?' + exclude_condition,
        true, false, self.id, start_date
      ]
    )
    logger.debug( available )
    if ( available > self.total_count )
      available = total_count
      # TODO: Generate warning message for user?
      logger.warn( "After counting non-returned ItemRentals, the number of available items (id: #{self.id}) is bigger than the total_count." )
    end
    
    available -= ItemRental.sum(
      :quantity,
      :include => [ :rental_action ],
      :conditions => [
        'handed_out = ? AND item_id = ? AND rental_actions.start_date <= ? AND rental_actions.end_date >= ?' + exclude_condition,
        false, self.id, end_date, start_date
      ]
    )
    logger.debug( available )
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
