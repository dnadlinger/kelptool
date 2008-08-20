class ItemQuantityChange < ActiveRecord::Base
  belongs_to :item
  
  validates_presence_of :reason, :message => 'Bitte geben Sie einen Grund ein.'
  validates_presence_of :amount, :message => 'Bitte geben Sie die Anzahl ein, um die sich der Bestand geändert hat.'
  
  validates_numericality_of :amount, :only_integer => true, :message => 'Anzahl ist ungültig.'
  
  before_save :update_item_count

  def event_date
    self.created_at
  end  
  
  def initialize( attrs = {}, &block )
    super attrs, &block
    if new_record?
      @old_amount = 0
    else
      @old_amount = self.amount
    end
    
  end
  
  protected
  
  def update_item_count
    delta = self.amount - @old_amount
    debugger
    self.item.total_count += delta
    self.item.num_in_stock += delta
    self.item.save!
  end
end
