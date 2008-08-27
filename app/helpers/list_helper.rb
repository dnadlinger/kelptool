module ListHelper
  include ActionView::Helpers::RecordIdentificationHelper
  
  def render_biglist( collection, name, options = {} )    
    if collection.empty?
      return "<p><em>Keine #{ name } gefunden.</em></p>"
    end
    
    if options[ :filter ]
      filter = options[ :filter ]
    else
      filter = lambda { |element| true }
    end
    
    content_tag :div, :class => 'big_list' do
      content_tag :ol do
        collection.collect do |element|
          if filter.call( element )
            content_tag :li, :id => dom_id( element ) do
              render :partial => element, :locals => parse_locals_option( options[ :locals ], element )
            end
          end
        end
      end
    end
  end
  
  def render_sublist( object, collection_attribute, name, options = {} )    
    container_id = "#{ dom_class( object ) }_#{ collection_attribute }"
    collection = options[ :collection ] || object.send( collection_attribute )
    
    content_tag :div, :class => 'sub_list', :id => container_id do
      content_tag :ol do
        unless collection.empty?
          collection.collect do |element|
            content_tag( :li, :id => dom_id( element ) ) do
              render :partial => element
            end
          end
        else
          content_tag( :li, "<em>Keine #{ name } gefunden.</em>" )
        end
      end
    end
  end
  
  def show_sublist_for( object, collection_attribute, name )
    container_id = "#{dom_class( object )}_#{collection_attribute}"
    content = object.send( collection_attribute )
    
    # The try/catch block is needed because a JS error is raised if the
    # container element does not exist.
    page << 'try {'
    page[ container_id ].remove
    page << '} catch(e) {}'
    
    page.insert_html :bottom, dom_id( object ), :inline => '<%= render_sublist( object, collection_attribute, name ) %>', :locals => { :object => object, :collection_attribute => collection_attribute, :name => name }
    #page.insert_html :bottom, dom_id( object ), :text => render_sublist( object, collection_attribute, name )
    page[ container_id ].select( 'ol' ).first.visual_effect( :blind_down, :duration => appear_duration_for( content ) )
  end
  
  def appear_duration_for( array )
    duration = 0.25
    unless array.empty? 
      duration *= array.count
    end
    return duration
  end
  
  private
    def parse_locals_option( option, element )
      return nil if option.nil?
      
      locals_hash = {}
      
      option.each do |key, value|
        if value.class == Hash
          locals_hash[ key ] = parse_locals_option( value, element )
        elsif value.class == Proc
          locals_hash[ key ] = value.call( element )
        else
          locals_hash[ key ] = value
        end
      end
      
      return locals_hash
    end
end
