class PhoneNumberType < ActiveRecord::Base
  validates_presence_of :name, :message => 'Bitte geben Sie einen Namen ein.'
  validates_uniqueness_of :name, :message => 'Ein Typ mit diesem Namen existiert bereits.'
end
