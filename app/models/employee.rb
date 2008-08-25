class Employee < ActiveRecord::Base
  has_and_belongs_to_many :skills
  belongs_to :contact
  
  validates_associated :contact, :message => 'Kontaktinformationen sind ungültig.'

  after_update :save_contact
  before_destroy :destroy_contact
  
  named_scope :with_skills, lambda { |skills|
    skills = [ skills ] if skills.class == Skill
    skill_ids = skills.collect( &:id )
    return {
      :select => 'employees.*',
      :readonly => false,
      :joins => 'INNER JOIN employees_skills ON employees_skills.employee_id = employees.id',
      :conditions => "employees_skills.skill_id IN ( #{ skill_ids.join( ', ' ) } )",
      :group => "employees_skills.employee_id HAVING count(*)=#{ skill_ids.size }"
    }
  }
  
  def contact_attributes=( attributes )
    if attributes[ :id ]
      self.contact = Contact.find( attributes[ :id ] )
    else
      build_contact if self.contact.nil?
      self.contact.attributes = attributes      
    end
  end
  
  def skills_attributes=( skill_attributes )
    self.skills.clear
    skill_attributes.each do |attributes|
      unless attributes[ 'name' ].blank?
        skill = Skill.find_or_create_by_name( attributes[ 'name' ] )
        self.skills << skill unless self.skills.include?( skill )
      end
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
end
