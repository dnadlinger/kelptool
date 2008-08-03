class ItemCategory < ActiveRecord::Base
  has_many :items
  
  acts_as_list
  
  validates_presence_of :name, :message => 'Der Name darf nicht leer sein.'
  validates_uniqueness_of :name, :message => 'Der Name wird bereits verwendet.'
end
