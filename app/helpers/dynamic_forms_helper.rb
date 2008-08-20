module DynamicFormsHelper
  def generate_unique_id( prefix )
    timestamp = Time.now.to_i.to_s
    timestamp.slice!( timestamp.length - 4, 4 )
    return prefix + timestamp + RandomTools.random_number_string( 2 )
  end
  
  def add_skill_link( use_select_menu = false )
    link_to_remote 'Fähigkeit hinzufügen', :url => { :controller => :skills, :action => :generate_skill_field, :use_select_menu => use_select_menu }, :method => :get
  end
  
  def fields_for_phone_number( path, phone_number, &block )
    prefix = phone_number.new_record? ? 'new' : 'existing'
    fields_for( "#{path}[#{prefix}_phone_numbers_attributes][]", phone_number, &block )
  end
  
  def add_phone_number_link( path )
    link_to_function 'Telefonnummer hinzufügen' do |page|
      page.insert_html :bottom, :phone_numbers, :partial => 'contacts/phone_number', :object => PhoneNumber.new, :locals => { :path => path }
    end
  end  
end
