class Employee < ActiveRecord::Base
  has_and_belongs_to_many :skills
  belongs_to :contact
  
  validates_associated :contact, :message => 'Kontaktinformationen sind ungültig.'

	after_update :save_contact
	
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
		build_contact if self.contact.nil?
		self.contact.attributes = attributes
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
  
	protected
	def save_contact
		self.contact.save!
	end
end
