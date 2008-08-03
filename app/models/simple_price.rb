class SimplePrice < ActiveRecord::Base
	has_one :item, :as => :price
	
	validates_numericality_of :daily_rate, :greater_than_or_equal_to => 0, :message => 'Bitte geben sie einen gültigen Tagessatz ein.'
	
	def get_price_for( timespan )
		days = ( timespan.to_f / 1.day.to_f ).ceil
		return self.daily_rate * days
	end
end
