class ContactSearch < ActiveRecord::BaseWithoutTable
	attr_accessor :name, :adress, :postcode, :place, :email, :uid
	
	def contacts
		find_contacts
	end
	
	def get_conditions
		prepare_conditions
	end
	
	protected
	
	include SearchConditions
	def find_contacts
	  Contact.all( :conditions => prepare_conditions )
	end
	
	def name_conditions
	  [ "contacts.name LIKE ?", "%#{ name }%" ] unless name.blank?
	end
	
	def adress_conditions
	  [ "contacts.adress LIKE ?", "%#{ adress }%" ] unless adress.blank?
	end
	
	def postcode_conditions
	  [ "contacts.postcode LIKE ?", "#{ postcode }%" ] unless postcode.blank?
	end
	
	def place_conditions
	  [ "contacts.place LIKE ?", "%#{ place }%" ] unless place.blank?
	end
	
	def email_conditions
	  [ "contacts.email LIKE ?", "%#{ email }%" ] unless email.blank?
	end
	
	def uid_conditions
	  [ "contacts.uid LIKE ?", "%#{ uid }%" ] unless uid.blank?
	end
end