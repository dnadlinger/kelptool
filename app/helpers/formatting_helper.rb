module FormattingHelper
  def format_number( number )
    number_with_delimiter( number, '&thinsp;', ',' )
  end
  
  def format_percent( factor )
    format_number( factor * 100 )
  end
  
  def format_currency( number )
    content_tag :span, :class => 'currency' do
      number_to_currency( number, :unit => '€', :separator => ',', :delimiter => '&thinsp;', :format => '%n&nbsp;%u' )
    end
  end
  
  
  def format_days( duration )
    string = ( duration.to_f / 1.day.to_f ).ceil.to_s
    string += ' Tag'
    string += 'e' if duration > 1.day
    return string
  end
end