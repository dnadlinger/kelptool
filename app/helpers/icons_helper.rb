module IconsHelper
  Icons = {
    :ok => { :file => 'icons/tick.png', :alt => 'Ok' },
    :warning => { :file => 'icons/error.png', :alt => 'Warnung' },
    :error => { :file => 'icons/exclamation.png', :alt => 'Fehler' },
    
    :edit => { :file => 'icons/pencil.png', :alt => 'Bearbeiten' },
    :delete => { :file => 'icons/bin_closed.png', :alt => 'Löschen' },
    :reset => { :file => 'icons/arrow_undo.png', :alt => 'Zurücksetzen' },    
    
    :up => { :file => 'icons/arrow_up.png', :alt => 'Hinauf' },
    :down => { :file => 'icons/arrow_down.png', :alt => 'Hinunter' },
    
    :add_child => { :file => 'icons/add.png', :alt => 'Hinzufügen' },
    
    :choose => { :file => 'icons/anchor.png', :alt => 'Wählen' },
    
    :search => { :file => 'icons/magnifier.png', :alt => 'Suchen' },
    :advanced_search => { :file => 'icons/application_form_magnify.png', :alt => 'Erweiterte Suche' },
    
    :plus => { :file => 'icons/add.png', :alt => 'Plus' },
    :minus => { :file => 'icons/delete.png', :alt => 'Minus' },
    
    :note => { :file => 'icons/note.png', :alt => 'Notiz' },
    :out_for_rental => { :file => 'icons/arrow_refresh.png', :alt => 'Vermietet' }
  }
  
  def icon( id, options = {} )
    icon_data = Icons[ id ]
    return nil unless icon_data
    
    options = options.reverse_merge( icon_data )
    file = options.delete( :file )
    
    image_tag( file, options )
  end
end