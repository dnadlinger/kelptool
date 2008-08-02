class ChoosingHelperController < ApplicationController
  def cancel_choosing
  	end_all_choosings
  	begin
  		redirect_to :back
  	rescue ActionController::RedirectBackError
  		redirect_to root_path	
  	end  	
  end
end
