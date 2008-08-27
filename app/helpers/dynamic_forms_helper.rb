# Based on a great idea by Jeff Dean (http://zilkey.com/2008/4/5/complex-forms-with-correct-ids).
module DynamicFormsHelper
  def collection_fields( object, collection_attribute, options = {} )
    # collection_attribute will presumably be a symbol.
    element_name = ActiveSupport::Inflector.singularize( collection_attribute.to_s )
    options.reverse_merge!(
      :partial_name => "#{ element_name }_field",
      :partial_locals => {},
      :parent_id => collection_attribute.to_s,
      :script_object_name => "#{ ActiveSupport::Inflector.camelize( element_name, false ) }Fields"
    )
    
    collection = object.send( collection_attribute )
    
    # We can't set this default via reverse_merge, because collection.build
    # would always be called and it might not exist on the collection
    # (e.g. if the collection is not an ActiveRecord association).
    unless options[ :new_object ]
      options[ :new_object ] = collection.build
      
      # Remove the created object from the collection, since we want to have
      # the association prepared on the element side, but not on the collection
      # side - it will be set up automatically when the record is saved.
      collection.delete( options[ :new_object ] )
    end
    
    
    template_html = render(
      :partial => options[ :partial_name ],
      :object => options[ :new_object ],
      :locals => options[ :partial_locals ].merge( { :list_position => 'LIST_POSITION' } )
    )
    javascript_code = "#{ options[ :script_object_name ] } = new CollectionFields( '#{ options[ :parent_id ] }', #{ collection.size }, '#{ escape_javascript( template_html ) }' );"
    content_for :head do
      javascript_tag javascript_code, :charset => 'utf-8'
    end
    
    returning '' do |html_string|
      collection.each_with_index do |element, index|
        html_string << render(
          :partial => options[ :partial_name ],
          :object => element,
          :locals => options[ :partial_locals ].merge( :list_position => index )
        )
      end
    end
  end
  
  def fields_for_collection_element( element, parent_path, collection_name, list_position, fields_for_options = {}, &block )
    index = element.new_record? ? list_position : element.id
    
    type = element.new_record? ? 'new' : 'existing'
    path = "#{ parent_path }[#{ type }_#{ collection_name }_attributes][]"
    
    parent_id_prefix = parent_path.gsub( '[', '_' ).gsub( ']', '' )
    html_id_prefix = "#{ parent_id_prefix }_#{ type }_#{ collection_name }_attributes_#{ index }_"
     
    fields_for path, element, :index => index do |form_builder|
      yield form_builder, html_id_prefix
    end
  end
end
