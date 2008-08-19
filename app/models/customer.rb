class Customer < ActiveRecord::Base
  belongs_to :contact
  has_many :rental_actions
  
  validates_associated :contact, :message => 'Kontaktinformationen sind ungültig.'
  validates_numericality_of :price_factor, :greater_than_or_equal_to => 0, :message => 'Preisfaktor ist ungültig. 1 entspricht einer normalen Preisgestaltung.'
  
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
