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
    
    result = link_to( ( useIcon ? icon_choose : 'Auswählen' ), build_choose_path( mode, *params ), :method => mode.choose_method )
    
    yield result
  end
end