class ItemDescription < ActiveRecord::Base
  belongs_to :item
  
  validates_presence_of :text, :message => 'Bitte geben Sie einen Beschreibungstext ein oder entfernen sie das Feld.'
end
