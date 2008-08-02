module ChoosingHelper
  def choose_link( mode, *params )
    build_link( mode, false, *params )
  end
  
  def choose_icon( mode, *params )
    build_link( mode, true, *params )
  end
  
  private
  def build_link( mode, useIcon, *params )
    unless mode == current_choosing_mode
      return nil
    end
    
    result = '<span class="alignright">'
    result << link_to( ( useIcon ? icon_choose : 'Auswählen' ), build_choose_path( mode, *params ), :method => mode.choose_method )
    result << '</span>'
    return result
  end
end