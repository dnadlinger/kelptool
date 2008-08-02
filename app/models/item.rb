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
	# We don't need to validate the number of the items in stock because the user can't directly mess around with it anyway.
	#validates_numericality_of :num_in_stock, :only_integer => true, :message => "Keine gültige Lagernd-Anzahl."
	
	def self.search( query )
		if query
			find( :all, :conditions => [ 'name LIKE ?', '%' + query + '%' ])
		else
			all
		end
	end
	
	def full_name
		return name
	end
end
