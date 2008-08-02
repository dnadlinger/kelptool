# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def show_errors( object, action_name )
		if object.errors.count > 0
			errors = ''
			object.errors.each do | attribute, message |
				errors << content_tag( :li, message )
			end
			
			complete_message = ''
			complete_message << content_tag( :p, 'Beim Versuch, ' + action_name + ', sind folgende Fehler aufgetreten:', :class => 'error' )
			complete_message << content_tag( :ul, errors )
			return content_tag( :div, complete_message, :class => 'form_error' )
    end
	end
end