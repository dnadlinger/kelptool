module RjsHelper
  include ActionView::Helpers::RecordIdentificationHelper
  
  def get_member_element( object, member_name )
    page[ dom_id( object ) ].select( ".#{dom_class( object )}_#{member_name}" ).first
  end
end
