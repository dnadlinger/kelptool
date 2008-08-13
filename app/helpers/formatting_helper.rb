module FormattingHelper
  def format_currency( number )
    content_tag :span, :class => 'currency' do
      number_to_currency( number, :unit => '€', :separator => ',', :delimiter => '&thinsp;', :format => '%n&nbsp;%u' )
    end
  end
end