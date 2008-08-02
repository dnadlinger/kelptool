class Skill < ActiveRecord::Base
  has_and_belongs_to_many :employees
  
  validates_presence_of :name, :message => 'Bitte geben Sie einen Namen für die Fähigkeit ein.'
  validates_uniqueness_of :name, :message => 'Diese Fähigkeit existiert bereits.'
end
