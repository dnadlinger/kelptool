class BillType
  class << self
    protected :new
  end
  def initialize( key, name )
    @key = key
    @name = name
    @@types ||= []
    @@types.push( self )
  end  

  
  Bid = self.new( 'A', 'Angebot' )
  Invoice = self.new( 'R', 'Rechnung' )
  DeliveryNote = self.new( 'L', 'Lieferschein' ) 
  
  
  attr_accessor :key, :name
  
  def self.find_by_key( key )
    return @@types.detect { |t| t.key == key }
  end
  
  def self.find_by_name( name )
    return @@types.detect { |t| t.name == name }
  end
  
  def self.all
    return @@types.dup
  end
end
