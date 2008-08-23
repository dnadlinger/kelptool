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
    'Wählen Sie das Gerät, das Sie hinzufügen möchten.',
    lambda { |source, item| "/rental_actions/#{ source.id }/item_rentals/new?item_id=#{ item.id }" },
    :get,
    lambda { |id| RentalAction.find( id ) },
    'Zurück zur Mietaktion'
  )
    
  RentalActionsChooseCustomer = ChoosingMode.new(
    'rental_actions_choose_customer',
    'Wählen Sie die Kundeninformationen für den Mietvorgang.',
    lambda { |source, customer| "/rental_actions/#{ source.id }/set_customer?customer_id=#{ customer.id }" },
    :put,
    lambda { |id| RentalAction.find( id ) },
    'Zurück zur Mietaktion'
  )
  
  RentalActionsChooseTemplate = ChoosingMode.new(
    'rental_actions_choose_template',
    'Wählen Sie die Vorlage für die neue Mietaktion.',
    lambda { |rental_action| "/rental_actions/new?template_id=#{ rental_action.id }" },
    :get
  )
  
  EmployeesChooseContactTemplate = ChoosingMode.new(
    'employees_choose_contact_template',
    'Wählen Sie den Kunden, von dem Sie die Kontaktinformationen übernehmen wollen.',
    lambda { |contact| "/employees/new?contact_id=#{ contact.id }" },
    :get
  )
  
  CustomersChooseContactTemplate = ChoosingMode.new(
    'customers_choose_contact_template',
    'Wählen Sie den Mitarbeiter, von dem Sie die Kontaktinformationen übernehmen wollen.',
    lambda { |contact| "/customers/new?contact_id=#{ contact.id }" },
    :get
  )
  
  RentalActionSearchesChooseCustomer = ChoosingMode.new(
    'rental_action_searches_choose_customer',
    'Wählen Sie den Kunden, in dessen Aufträgen Sie suchen möchten.',
    lambda { |customer| "/rental_actions/search/new?customer_id=#{ customer.id }" },
    :get,
    nil,
    'Zurück zur Suche',
    lambda { '/rental_actions/search/new' }
  )
end
