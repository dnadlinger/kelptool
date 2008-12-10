class Employee < ActiveRecord::Base
  belongs_to :contact
  before_destroy :destroy_contact
  validates_associated :contact, :message => 'Kontaktinformationen sind ungültig.'  
  
  has_and_belongs_to_many :skills
  attribute_for_collection :skills,
    :build_new => lambda { |this, attributes| this.send( :add_skill, attributes ) },
    :update_existing => lambda { |this, attributes, element| this.send( :add_skill, attributes, element ) }
  
  named_scope :with_skills, lambda { |*skills|
    skill_ids = skills.flatten.uniq.collect( &:id )
    return {
      :select => 'employees.*',
      :readonly => false,
      :joins => 'INNER JOIN employees_skills ON employees_skills.employee_id = employees.id',
      :conditions => "employees_skills.skill_id IN ( #{ skill_ids.join( ', ' ) } )",
      :group => "employees_skills.employee_id",
      :having => "count(*)=#{ skill_ids.size }"
    }
  }
  
  after_update :save_contact
  
  def contact_attributes=( attributes )
    if attributes[ :id ]
      self.contact = Contact.find( attributes[ :id ] )
    else
      build_contact if self.contact.nil?
      self.contact.attributes = attributes      
    end
  end
  
  
  private
    def save_contact
      self.contact.save!
    end
    
    def destroy_contact
      unless self.contact.employee
        self.contact.destroy
      end
    end
    
    def add_skill( attributes, element = nil )
      self.skills.delete( element ) if element
      unless attributes[ 'name' ].blank?
        skill = Skill.find_or_create_by_name( attributes[ 'name' ] )
        self.skills << skill unless self.skills.include?( skill )
      end
    end
end
