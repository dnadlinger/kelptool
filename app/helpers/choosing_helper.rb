module ChoosingHelper
  def choose_link( mode, *params, &block )
    block = lambda { |link| content_tag :p, link } unless block
    build_link( mode, false, *params, &block )
  end
  
  def choose_icon( mode, *params, &block )
    block = lambda { |link| content_tag :span, link, :class => 'alignright' } unless block
    build_link( mode, true, *params, &block )
  end
  
  private
  def build_link( mode, useIcon, *params, &block )
    unless mode == current_choosing_mode
      return nil
    end
    
    options = {}
    if mode.choose_method != :get
      options[ :method ] = mode.choose_method
    end
    
    result = link_to( ( useIcon ? icon( :choose ) : 'Auswählen' ), build_choose_path( mode, *params ), options )
    
    yield result
  end
end