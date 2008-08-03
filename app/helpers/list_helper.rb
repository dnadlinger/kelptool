module ListHelper
  include ActionView::Helpers::RecordIdentificationHelper
  
  def render_biglist( collection, name )
    if collection.empty?
      return "<p><em>Keine #{name} gefunden.</em></p>"
    end
    
    content_tag :div, :class => 'biglist' do
      content_tag :ol do
        render :partial => collection
      end
    end
  end
  
  def render_sublist( object, collection_attribute, name )
    container_id = "#{dom_class( object )}_#{collection_attribute}"
    collection = object.send collection_attribute
    
    return content_tag( :div, :class => 'sublist', :id => container_id ) do
      content_tag :ol do
        unless collection.empty?
          render :partial => collection
        else
          content_tag :li, "<em>Keine #{name} gefunden.</em>"
        end
      end
    end
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
end