class ApplicationController < ActionController::Base
  # By default, a valid login is needed for the whole site.
  include AuthenticatedSystem
  before_filter :login_required
  
  # include all helpers, all the time
  helper :all

  # See ActionController::RequestForgeryProtection for details
  protect_from_forgery
  
  # See ActionController::Base for details
  # filter_parameter_logging :password
  
  include ChoosingSystem
  
  def prepare_auto_completion_query( query )
    prepared = query
    
    if prepared[ -3..-1 ] == '...'
      prepared = query[ 0..-4 ]
    end
    
    return prepared
  end
 end
