class PhoneNumber < ActiveRecord::Base
	belongs_to :contact
	belongs_to :type, :class_name => 'PhoneNumberType'
	
	validates_presence_of :number, :message => 'Bitte geben Sie eine Telefonnummer ein oder entfernen Sie das Feld.'
	validates_presence_of :type_id, :message => 'Bitte wählen Sie den Typ der Telefonnummer aus.'
	
	validates_associated :type, :message => 'Der Typ der Telefonnummer ist ungültig.'
end
