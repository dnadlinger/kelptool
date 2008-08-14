class Customer < ActiveRecord::Base
  belongs_to :contact
  has_many :rental_actions
  
  validates_associated :contact, :message => 'Kontaktinformationen sind ungültig.'
  validates_numericality_of :discount, :message => 'Preis (in Promille) ist ungültig. Geben Sie für normale Preisgestaltung 1000 ein.'
  
  after_update :save_contact
  
  def contact_attributes=( attributes )
    build_contact if self.contact.nil?
    self.contact.attributes = attributes
  end
  
  protected
  def save_contact
    self.contact.save!
  end  
end
