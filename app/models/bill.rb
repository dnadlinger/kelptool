class Bill < ActiveRecord::Base
  belongs_to :rental_action
  belongs_to :db_file, :dependent => :destroy
  
  has_attachment :content_type => [ Mime::PDF.to_s, Mime::XLS.to_s, Mime::XLSX.to_s ], :storage => :db_file
  
  validates_inclusion_of :type_key, :in => BillType.all.collect( &:key ), :message => 'Bitte wählen Sie die Art der Rechnung.'
  validates_numericality_of :serial_number, :message => 'Die laufende Nummer ist ungültig.'
  
  
  def bill_type
    BillType.find_by_key( self.type_key )
  end
  
  def bill_type=( bill_type )
    self.type_key = bill_type.key
  end
  
  
  def reference
    self.type_key + Time.now.year.to_s + self.serial_number.to_s
  end
  
  def extension
    self.filename.split( '.' ).last
  end
end
