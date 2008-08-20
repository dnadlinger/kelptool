silence_warnings do
  Date::MONTHNAMES = [nil] + %w(Jänner Februar März April Mai Juni Juli August September Oktober November Dezember)
  Date::DAYNAMES = %w(Sonntag Montag Dienstag Mittwoch Donnerstag Freitag Samstag)
  Date::ABBR_MONTHNAMES =  [nil] + %w(Jän Feb Mär Apr Mai Jun Jul Aug Sep Okt Nov Dez) 
  Date::ABBR_DAYNAMES = %w(So Mo Di Mi Do Fr Sa)
   
  Time::MONTHNAMES = Date::MONTHNAMES
  Time::DAYNAMES = Date::DAYNAMES
  Time::ABBR_MONTHNAMES = Date::ABBR_MONTHNAMES
  Time::ABBR_DAYNAMES = Date::ABBR_DAYNAMES
end
