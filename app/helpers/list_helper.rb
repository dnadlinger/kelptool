module ListHelper
  include ActionView::Helpers::RecordIdentificationHelper
  
  def render_biglist( collection, name, *args )    
    if collection.empty?
      return "<p><em>Keine #{name} gefunden.</em></p>"
    end
    
    options = args.extract_options!
    
#    content_tag :div, :class => 'biglist' do
#      content_tag :ol do
#        collection.each do |element|
#          content_tag :li, element do
#            render :partial => element 
#          end
#        end
#      end
#    end
    html_string = ''
    collection.each do |element|
      unless options[ :filter ] && !( options[ :filter ].call( element ) )
        html_string << '<li id="' + dom_id( element ) + '">'
        html_string << render( :partial => element, :locals => parse_locals_option( options[ :locals ], element ) )
        html_string << '</li>'
      end
    end
    html_string = content_tag :ol, html_string
    html_string = content_tag :div, html_string, :class => 'biglist'
    
    return html_string
  end
  
  def render_sublist( object, collection_attribute, name, *args )
    options = args.extract_options!
    
    container_id = "#{dom_class( object )}_#{collection_attribute}"
    collection = options[ :collection ] || object.send( collection_attribute )
    
    html_string = ''
    unless collection.empty?
      collection.each do |element|
        html_string << '<li id="' + dom_id( element ) + '">'
        html_string << render( :partial => element )
        html_string << '</li>'
      end
    else
      html_string << content_tag( :li, "<em>Keine #{name} gefunden.</em>" )
    end
    
    html_string = content_tag :ol, html_string
    html_string = content_tag :div, html_string, :class => 'sublist', :id => container_id
    
    return html_string
  end
  
  def show_sublist_for( object, collection_attribute, name )
    container_id = "#{dom_class( object )}_#{collection_attribute}"
    content = object.send collection_attribute
    
    # The try/catch block is needed because a JS error is raised if the
    # container element does not exist.
    page << 'try {'
    page[ container_id ].remove
    page << '} catch(e) {}'
    
    page.insert_html :bottom, dom_id( object ), :inline => '<%= render_sublist( object, collection_attribute, name ) %>', :locals => { :object => object, :collection_attribute => collection_attribute, :name => name }
    #page.insert_html :bottom, dom_id( object ), :text => render_sublist( object, collection_attribute, name )
    page[ container_id ].select( "ol" ).first.visual_effect( :blind_down, :duration => appear_duration_for( content ) )
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