require 'rubygems'
require 'unitwise'
require 'colorize'

# Do Not Remove This File
# This file contains assertion methods which are called from conveyor_belt_steps.rb

# Method to insert SockJS client js file and test js file to page header
def insert_js_to_page_header(*args)
  if args.length > 1
    raise ArgumentError, 'Too many arguments, a max of 1 argument is supported for now'
  elsif args.length == 0
    # inserting SockJS client file to the head of current webpage so that test js files with SockJS commands can work
    js_script = "var s=window.document.createElement('script');\
    s.src='http://10.102.11.196/js/sockjs.min.js';\
    window.document.head.appendChild(s);"
    # alternatively s.src='https://cdn.jsdelivr.net/sockjs/1/sockjs.min.js';\ can also be used
    puts "Inserting SockJS client file: sockjs.min.js to page header!"
  else
    if args.first == "length"
      js_script = "var s=window.document.createElement('script');\
      s.src='http://10.102.11.196/js/length.js';\
      window.document.head.appendChild(s);"
      puts "Inserting length.js to page header! This will connect to SockJS websocket, and subscribe to channel that sends length information for each object."
    elsif args.first == "width"
      js_script = "var s=window.document.createElement('script');\
      s.src='http://10.102.11.196/js/width.js';\
      window.document.head.appendChild(s);"
      puts "Inserting width.js to page header! This will connect to SockJS websocket, and subscribe to channel that sends width information for each object."
    elsif args.first == "height"
      js_script = "var s=window.document.createElement('script');\
      s.src='http://10.102.11.196/js/height.js';\
      window.document.head.appendChild(s);"
      puts "Inserting height.js to page header! This will connect to SockJS websocket, and subscribe to channel that sends height information for each object."
    elsif args.first == "speed"
      js_script = "var s=window.document.createElement('script');\
      s.src='http://10.102.11.196/js/speed.js';\
      window.document.head.appendChild(s);"
      puts "Inserting speed.js to page header! This will connect to SockJS websocket, and subscribe to channel that sends speed information for each object."
    elsif args.first == "atw"
      js_script = "var s=window.document.createElement('script');\
      s.src='http://10.102.11.196/js/atw.js';\
      window.document.head.appendChild(s);"
      puts "Inserting atw.js to page header! This will connect to SockJS websocket, and subscribe to channel that sends data of each object for all columns in ATW widget."
    else
      puts "Please recheck step. Only \"length\", \"width\", \"height\", \"speed\" & \"atw\" can be used as valid channel names in this step for now."
      raise TestCaseFailed, 'Incorrect channel name specified in Step'
    end
  end
  $driver.execute_script(js_script)
  # # writing a message in browser console for debug
  # $driver.execute_script("console.log('Automation test for SockJS websocket connection begun!');")
  step %[I wait for 1 sec]  # to ensure that js files get inserted in the order they were sent
end

# Method to check if a javascript alert is present or not
def is_js_alert_present
  begin
    WAIT.until{ $driver.switch_to.alert }
    return true
  rescue Exception => e
    return false
  end
end

# Method to read text from javascript alert and store dimension value in an array for comparison later
def get_values_from_ws
  step %[I wait for 2 sec] # No/less wait can cause selenium to miss alert presence and exit the test even before the first alert appears
  i=0
  get_alert_text = Array.new
  until !is_js_alert_present do
    get_alert_text[i] = WAIT.until{ $driver.switch_to.alert }.text   # another alternative method (should avoid) is to print all messages to console log and then copy the whole console log -- console_logs = $driver.manage.logs.get(:browser); puts console_logs
    puts get_alert_text[i]
    $driver.switch_to.alert.accept
    get_alert_text[i] = get_alert_text[i].tr('{}', '').gsub('"', '').split(':')[-1].to_f # getting payload value from the raw string
    step %[I wait for 2 sec] # because simulator is pushing object every 2000 ms
    i+=1
  end
  return get_alert_text
end

# Method to read text from javascript alert and store raw text in an array for comparison later
def get_atw_values_from_ws
  step %[I wait for 2 sec] # No/less wait can cause selenium to miss alert presence and exit the test even before the first alert appears
  WAIT.until{ $driver.switch_to.alert }.accept # accept alert with belt_update details before streaming data to ATW
  step %[I wait for 1 sec]
  i=0
  get_alert_text = Array.new
  until !is_js_alert_present do
    get_alert_text[i] = WAIT.until{ $driver.switch_to.alert }.text   # another alternative method (should avoid) is to print all messages to console log and then copy the whole console log -- console_logs = $driver.manage.logs.get(:browser); puts console_logs
    get_alert_text[i] = get_alert_text[i].tr('{}', '').gsub('"', '')
    $driver.switch_to.alert.accept
    step %[I wait for 2 sec] # because simulator is pushing object every 2000 ms
    i+=1
  end
  return get_alert_text
end
#
# # Method to convert the value in a particular dimension unit read from XML to meters for standard comparison.
# def convert_dimension_unit_to_meter(values, units)
  # if values.size == units.size
    # for i in 0..values.size - 1
      # values[i] = Unitwise(values[i].to_f, units[i]).to_meter.to_f.round(2)
    # end
  # else
    # puts "The count of dimension values and count of unit values do not match."
    # raise TestCaseFailed, 'Something wrong with test data pushed via sims.'
  # end
  # return values
# end
#
# # Method to convert the value in a particular scale unit read from XML to kilograms for standard comparison.
# def convert_scale_unit_to_kg(values, units)
  # if values.size == units.size
    # for i in 0..values.size - 1
      # values[i] = Unitwise(values[i].to_f, units[i]).to_kg.to_f.round(2)
    # end
  # else
    # puts "The count of scale values and count of unit values do not match."
    # raise TestCaseFailed, 'Something wrong with test data pushed via sims.'
  # end
  # return values
# end
#
# # Method to convert the speed value in complex unit such as ft/min read from XML to m/s for standard comparison.
# def convert_speed_to_meter_per_sec(values, units)
  # if values.size == units.size
    # for i in 0..values.size - 1
      # if units[i] == "ft/min"
        # values[i] = (values[i].to_f * 0.00508).round(2) # Unitwise cannot convert speed values with unit ft/min to m/s out of the box
      # else
        # values[i] = Unitwise(values[i].to_f, units[i]).convert_to('m/s').to_f.round(2) # Unitwise can convert speed values with unit km/hour or mile/hour to m/s out of the box
      # end
    # end
  # else
    # puts "The count of speed values and count of unit values do not match."
    # raise TestCaseFailed, 'Something wrong with test data pushed via sims.'
  # end
  # return values
# end

# Method to check validity of a unit before unit conversion.
def unit_validity(desired_unit)
  return Unitwise.valid?(desired_unit)
end

# Method to check compatibility of two units before conversions.
def unit_compatibility(source_unit, desired_unit)
  return Unitwise(1, source_unit).compatible_with?Unitwise(1, desired_unit)
end

def source_val_match_with_output_val(source_val, source_unit, obtained_val, obtained_unit)
  return Unitwise(source_val, source_unit) == Unitwise(obtained_val, obtained_unit)
end

# Method to change some unit abbreviations to full names as unitwise does not perform conversions with some unit's abbreviations.
# For example, if:
# units = ["ft", "m", "km", "foot", "mm", "lb", "m/s", "ft/min", "lbs"]
# unit_abbrv = { 'ft' => 'foot', 'lbs' => 'pound', 'lb' => 'pound' }
# then output will be: units = ["foot", "m", "km", "foot", "mm", "pound", "m/s", "ft/min", "pound"]
def fix_unit_abbrv(units)
  units.each {|unit| unit_abbrv.map { |k, v| unit.sub!(k, v) } }
  return units
end

# Method to convert the speed value in ft/min to a desired unit to standard m/s for comparison as unitwise doesn't support ft/min conversions out of the box.
def convert_ft_per_min_to_m_per_sec(value)
  value = (value.to_f * 0.00508).round(2)
  return value
end

# Method to compare the values read from XML with values obtained from websocket stream.
def compare_websocket_data_with_xml(values_from_xml, units_from_xml, values_from_ws, units_from_ws)
  val_mismatch_count = 0
  if values_from_xml.size == values_from_ws.size || units_from_xml.size == units_from_ws.size
    for i in 0..values_from_xml.size - 1
      if unit_validity(units_from_xml[i]) && unit_validity(units_from_ws[i]) && unit_compatibility(units_from_xml[i], units_from_ws[i])
        if source_val_match_with_output_val
          puts "Object value from XML: \"#{values_from_xml[i]} #{units_from_xml[i]}\" is equivalent to converted value sent over websocket: \"#{values_from_ws[i]} #{units_from_ws[i]}\""#.green #-- cucumber html reports doesn't like/honor the colorise gem's colors
        else
          puts "Object value in XML: \"#{values_from_xml[i]} #{units_from_xml[i]}\" is not equivalent to the value sent over websocket: \"#{values_from_ws[i]} #{units_from_ws[i]}\""#.red
          val_mismatch_count +=1
        end
      else
        puts "Unit are either not valid or not comptible for conversion."
        raise TestCaseFailed, 'Invalid or non-compatible units'
      end
    end
    if val_mismatch_count > 0
      raise TestCaseFailed, 'Values of %{count}/%{total} objects did not match exactly with their corresponding values obtained from websocket stream.' % {count: val_mismatch_count, total: values_from_xml.size}
    end
  else
    puts "Number of objects/units sent by sims does not match with number of objects/units obtained from websocket stream."
    raise TestCaseFailed, 'Object/unit count mismatch bewteen sims and websocket stream.'
  end
end