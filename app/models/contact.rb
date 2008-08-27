class Contact < ActiveRecord::Base 
  # A contact will usually belong to one of these:
  has_one :customer
  has_one :employee
  
  has_many :phone_numbers, :dependent => :destroy
  
  validates_presence_of :name, :message => 'Bitte geben Sie einen Namen ein.'  
  validates_presence_of :adress, :message => 'Bitte geben Sie eine Adresse ein.'
  validates_presence_of :postcode, :message => 'Bitte geben Sie eine Postleitzahl ein.'
  validates_presence_of :place, :message => 'Bitte geben Sie einen Ort (nur den Namen) ein.'
  
  validates_associated :phone_numbers, :message => 'Nicht alle Telefonnummern sind gültig.'
  
  attribute_for_collection :phone_numbers
  
  def full_place
    return postcode + " " + place
  end
end
