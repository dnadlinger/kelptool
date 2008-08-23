class RentalActionSearch < ActiveRecord::BaseWithoutTable
  column :name, :string
  column :date, :date
  column :customer_id, :integer
  
  attr_accessor :customer
  
  def rental_actions
    find_rental_actions
  end
  
  private
    include SearchConditions
    def find_rental_actions
      RentalAction.all( :conditions => prepare_conditions )
    end
    
    def name_conditions
      [ "name LIKE ?", "%#{ name }%" ] unless name.blank?
    end
    
    def date_conditions
      [ "( ( ? <= start_date AND start_date <= ? ) OR ( ? <= end_date AND end_date <= ? ) )", date.beginning_of_month, date.end_of_month, date.beginning_of_month, date.end_of_month ] unless date.blank?
    end
    
    def customer_conditions
      search_id = unless customer.blank?
          customer.id
        else
          unless customer_id.blank?
            customer_id
          end
      end
      
      [ "customer_id = ?", search_id ] unless search_id.blank?
    end
end