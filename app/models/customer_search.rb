class CustomerSearch < ActiveRecord::BaseWithoutTable
  column :comment, :string
  attr_accessor :contact
  
  def customers
    find_customers
  end
  
  protected
  
  include SearchConditions
  def find_customers
    Customer.all( :conditions => prepare_conditions, :include => :contact )
  end
  
  def comment_conditions
    [ "customers.comment LIKE ?", "%#{ comment }%" ] unless comment.blank?
  end
  
  def contact_conditions
    contact.get_conditions unless contact.nil?
  end
end