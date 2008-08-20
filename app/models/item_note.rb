class ItemNote < ActiveRecord::Base
  belongs_to :item
  
  validates_presence_of :content, :message => 'Bitte geben Sie eine Notiz ein.'
  
  def event_date
    self.created_at
  end
end
