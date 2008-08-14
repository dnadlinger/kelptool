module IconsHelper
  def icon_up
    image_tag( 'icons/arrow_up.png', :alt => 'Hinauf' )
  end
  
  def icon_down
    image_tag( 'icons/arrow_down.png', :alt => 'Hinunter' )
  end
  
  def icon_add_child
    image_tag( 'icons/add.png' )
  end
  
  def icon_edit
    image_tag( 'icons/pencil.png', :alt => 'Bearbeiten' )
  end
  
  def icon_delete
    image_tag( 'icons/bin_closed.png', :alt => 'Löschen' )
  end
  
  def icon_reset
    image_tag( 'icons/arrow_undo.png', :alt => 'Zurücksetzen' )
  end
  
  def icon_ok
    image_tag( 'icons/tick.png', :alt => 'Ok' )
  end
  
  def icon_error
    image_tag( 'icons/exclamation.png', :alt => 'Fehler' )
  end
  
  def icon_choose
    image_tag( 'icons/anchor.png', :alt => 'Wählen' )
  end
  
  def icon_search
    image_tag( 'icons/find.png', :alt => 'Suchen' )
  end
  
  def icon_warning
    image_tag( 'icons/error.png', :alt => 'Warnung' )
  end
end