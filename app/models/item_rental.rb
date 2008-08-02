class ItemRental < ActiveRecord::Base
	belongs_to :item
	belongs_to :rental_action
	
	validates_numericality_of :quantity, :greater_than => 0, :message => 'Ungültige Anzahl (muss mindestens 1 sein).'
	
	def price
		self.item.price.get_price_for( self.rental_action.duration ) * self.quantity
	end
end
