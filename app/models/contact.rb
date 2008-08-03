class Contact < ActiveRecord::Base 
  # A contact will usually belong to one of these:
  has_one :customer
  has_one :employee
  
  has_many :phone_numbers
  
  validates_presence_of :name, :message => 'Bitte geben Sie einen Namen ein.'
  validates_uniqueness_of :name, :message => 'Kontaktinformationen mit diesem Namen existieren bereits.'
  
  validates_presence_of :adress, :message => 'Bitte geben Sie eine Adresse ein.'
  validates_presence_of :postcode, :message => 'Bitte geben Sie eine Postleitzahl ein.'
  validates_presence_of :place, :message => 'Bitte geben Sie einen Ort (nur den Namen) ein.'
  
  validates_associated :phone_numbers, :message => 'Nicht alle Telefonnummern sind gültig.'
  
  after_update :save_phone_numbers
  
  def full_place
    return postcode + " " + place
  end
  
  def new_phone_numbers_attributes=( phone_numbers_attributes )
    phone_numbers_attributes.each do |attributes|
      phone_numbers.build( attributes )
    end
  end
  
  def existing_phone_numbers_attributes=( phone_numbers_attributes )
    phone_numbers.reject( &:new_record? ).each do |phone_number|
      attributes = phone_numbers_attributes[ phone_number.id.to_s ]
      if attributes
        phone_number.attributes = attributes
      else
        phone_numbers.delete( phone_number )
      end
    end
  end
  
  protected
  
  def save_phone_numbers
    phone_numbers.each do |number|
      number.save( false )
    end
  end
end
