class ChoosingMode
  def initialize( name, message, build_choose_path, choose_method, get_source_by_id = nil, source_name = nil, build_source_path = nil, source_method = :get )
    # TODO: How to make this private?
    @name = name
    @message = message
    
    @build_choose_path = build_choose_path
    @choose_method = choose_method
    
    @get_source_by_id = get_source_by_id
    @source_name = source_name
    @build_source_path = build_source_path
    @source_method = source_method
  end
  
  attr_accessor :name, :message, :source_name, :choose_method, :source_method
  
  def choose_path( *params )
    @build_choose_path.call( *params )
  end
  
  def has_source?
  	return @source_name != nil
  end
  
  def source_by_id( id )
  	return nil unless @get_source_by_id
    @get_source_by_id.call( id )
  end
  
  def source_path( *params )
    return nil unless @build_source_path
    @build_source_path.call( *params )
  end
  
  def self.find_by_name( name )
    result = nil
    ObjectSpace.each_object( ChoosingMode ) do |mode|
      if mode.name == name
        result = mode
        break
      end
    end
    return result
  end
  
  ItemRentalsChooseItem = ChoosingMode.new(
    'item_rentals_choose_item',
    'Navigieren sie zum Gerät, das Sie hinzufügen möchten, und klicken Sie auf "Auswählen".',
    lambda { |source, item| '/rental_actions/' + source.id.to_s + '/item_rentals/new?item_id=' + item.id.to_s },
    :get,
    lambda { |id| RentalAction.find( id ) },
    'Zurück zur Mietaktion'
  )
    
  RentalActionsChooseCustomer = ChoosingMode.new(
    'rental_actions_choose_customer',
    'Navigieren sie zu den Kundeninformationen für den Auftrag und klicken Sie auf "Auswählen".',
    lambda { |source, customer| '/rental_actions/' + source.id.to_s + '/set_customer?customer_id=' + customer.id.to_s },
    :put,
    lambda { |id| RentalAction.find( id ) },
    'Zurück zur Mietaktion'
  )
  
  RentalActionsChooseTemplate = ChoosingMode.new(
    'rental_actions_choose_template',
    'Navigieren sie zum Gerät, das Sie hinzufügen möchten, und klicken Sie auf "Auswählen".',
    lambda { |rental_action| '/rental_actions/new?template_id=' + rental_action.id },
    :get
  )
  
  EmployeesChooseContactTemplate = ChoosingMode.new(
    'employees_choose_contact_template',
    'Navigieren sie zum Kunden, von dem Sie die Kontaktinformationen übernehmen wollen, und klicken Sie auf "Auswählen".',
    lambda { |contact| '/employees/new?contact_id=' + contact.id.to_s },
    :get
  )
end