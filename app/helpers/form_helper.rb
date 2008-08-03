module FormHelper
  def pretty_form_for( record, *args, &block)
    options = args.extract_options!
    options[ :html ] ||= {}
    options[ :html ][ :class ] = [ 'pretty', options[ :html ][ :class ] ].compact.join( ' ' )
    
    form_for( record, *( args << options ), &block )
  end
  
  def edit_form_for( record, *args, &block )
    options = args.extract_options!
    options[ :html ] ||= {}
    options[ :html ].merge!( { :method => :put } )
    
    pretty_form_for( record, *( args << options ), &block )
  end
  
  def show_errors( record, action_name )
    return nil if record.errors.empty?
    
    content_tag :div, :class => 'form_error' do
      content_tag( :p, 'Beim Versuch, ' + action_name + ', sind folgende Fehler aufgetreten:', :class => 'error' )
      content_tag :ul do
        record.errors.each do |attribute, message|
          content_tag( :li, message )
        end
      end
    end
  end
  
  # Adds AJAX autocomplete functionality to the text input field with the 
  # DOM ID specified by +field_id+.
  def auto_complete_field(field_id, options = {})
    function =  "var #{field_id}_auto_completer = new Ajax.Autocompleter("
    function << "'#{field_id}', "
    function << "'" + (options[:update] || "#{field_id}_auto_complete") + "', "
    function << "'#{url_for(options[:url])}'"
    
    js_options = {}
    js_options[:tokens] = array_or_string_for_javascript(options[:tokens]) if options[:tokens]
    js_options[:callback]   = "function(element, value) { return #{options[:with]} }" if options[:with]
    js_options[:indicator]  = "'#{options[:indicator]}'" if options[:indicator]
    js_options[:select]     = "'#{options[:select]}'" if options[:select]
    js_options[:paramName]  = "'#{options[:param_name]}'" if options[:param_name]
    js_options[:frequency]  = "#{options[:frequency]}" if options[:frequency]
    js_options[:method]     = "'#{options[:method].to_s}'" if options[:method]

    { :after_update_element => :afterUpdateElement, 
      :on_show => :onShow, :on_hide => :onHide, :min_chars => :minChars }.each do |k,v|
      js_options[v] = options[k] if options[k]
    end

    function << (', ' + options_for_javascript(js_options) + ')')

    javascript_tag(function)
  end
  
  # Use this method in your view to generate a return for the AJAX autocomplete requests.
  def auto_complete_result(entries, field, phrase = nil)
    return unless entries
    items = entries.map { |entry| content_tag("li", phrase ? highlight(entry[field], phrase) : h(entry[field])) }
    content_tag("ul", items.uniq)
  end
  
  # Wrapper for text_field with added AJAX autocompletion functionality.
  def text_field_with_auto_complete(object, method, tag_options = {}, completion_options = {})
    text_field(object, method, tag_options) +
    content_tag("div", "", :id => "#{object}_#{method}_auto_complete", :class => "auto_complete") +
    auto_complete_field("#{object}_#{method}", { :url => { :action => "auto_complete_for_#{object}_#{method}" } }.update(completion_options))
  end
end