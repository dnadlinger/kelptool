class EmployeeSearch < ActiveRecord::BaseWithoutTable
  column :comment, :string
  attr_accessor :contact, :skills
  
  def employees
    find_employees
  end
  
  attribute_for_collection :skills,
    :build_new => lambda { |this, attributes| this.skills ||= []; this.skills << Skill.find_by_name( attributes[ :name ] ) }
    # We don't need to provide a custom update_existing hook, because due to
    # the non-persistent nature of this class, it would never be called.
    
  private
    include SearchConditions
    def find_employees
      unless skills.blank?
        Employee.with_skills( skills ).all( :conditions => prepare_conditions, :include => :contact )
      else
        Employee.all( :conditions => prepare_conditions, :include => :contact )
      end
    end
    
    def comment_conditions
      [ "employees.comment LIKE ?", "%#{ comment }%" ] unless comment.blank?
    end
    
    def contact_conditions
      contact.get_conditions unless contact.nil?
    end
end
