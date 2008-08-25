class Customer < ActiveRecord::Base    
  belongs_to :contact
  has_many :rental_actions
  
  validates_associated :contact, :message => 'Kontaktinformationen sind ungültig.'
  validates_numericality_of :price_factor, :greater_than_or_equal_to => 0, :message => 'Preisfaktor ist ungültig. 1 bzw. 100% entspricht einer normalen Preisgestaltung.'
  
  after_update :save_contact
  before_destroy :destroy_contact
  
  def contact_attributes=( attributes )
    if attributes[ :id ]
      self.contact = Contact.find( attributes[ :id ] )
    else
      build_contact if self.contact.nil?
      self.contact.attributes = attributes      
    end
  end
  
  private
    def save_contact
      self.contact.save!
    end
  
    def destroy_contact
      unless self.contact.employee
        self.contact.destroy
      end
    end
end
