module ChoosingSystem
  protected
    def start_choosing( mode, source_object = nil )
      unless session[ :choosing_mode ].nil?
        raise 'There is another choosing mode active: ' + session[ :choosing_mode ]
      end
      
      session[ :choosing_mode ] = mode.name
      session[ :choosing_source_id ] = source_object.id if source_object
    end
    
    def end_choosing( mode )
      if session[ :choosing_mode ] == mode.name
        session[ :choosing_mode ] = nil
        session[ :choosing_source_id ] = nil
      end
    end
    
    def end_all_choosings
      session[ :choosing_mode ] = nil
      session[ :choosing_source_id ] = nil
    end
    
    def currently_choosing?
      not session[ :choosing_mode ].nil?
    end
    
    def choosing_mode_active?( mode )
      return current_choosing_mode == mode 
    end
    
    def current_choosing_mode
      unless currently_choosing?
        return nil
      end
      
      mode = ChoosingMode.find_by_name( session[ :choosing_mode ] )
      if mode.nil?
        raise 'There is an unregistered choosing mode active.'
      end
      
      return mode
    end
    
    def build_choose_path( mode, *params )
      if mode.has_source?
        params.unshift( get_source( mode ) )
        # If the source is nil, we also don't want to pass it.
        params.compact!
      end
      mode.choose_path( *params )
    end
    
    def build_source_path( mode )
      return nil unless mode.has_source?
      source_path = mode.source_path
      
      # If the mode has no specific source_path, but a source_name,
      # try just getting the url_for the source_object 
      source_path ||= url_for( get_source( mode ) )
    end
    
  private
    def get_source( mode )
      mode.source_by_id( session[ :choosing_source_id ] )
    end
    
    # Inclusion hook for making the methods available in the views (taken from AuthenticatedSystem)
    def self.included( base )
      base.send :helper_method, :start_choosing, :end_choosing, :currently_choosing?, :current_choosing_mode, :build_choose_path, :build_source_path
    end
end
