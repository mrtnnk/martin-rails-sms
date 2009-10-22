module SMSFuHelper  
  # Returns a collection of carriers to be used in your own select tag
  # e.g., <%= f.select :mobile_carrier, carrier_collection %>
  def carrier_collection
    SMSFu.carriers.sort.collect{ |carrier| [carrier[1]["name"], carrier[0]] }
  end
  
  # Returns a formatted select box filled with carriers
  # e.g., <%= carrier_select %>
  # - name => name of the method in which you want to store the carrier name
  # - phrase => default selected blank option in select box 
  # - selected => carrier to pre-select
  def carrier_select(name = :mobile_carrier, phrase = "Select a Carrier", selected = nil)
    select_tag name, options_for_select([phrase,nil]+carrier_collection, selected || phrase)
  end

  def carrier_select_default(name = :mobile_carrier, default = nil)
    select_tag name, options_for_select([nil]+carrier_collection, default)
  end
end