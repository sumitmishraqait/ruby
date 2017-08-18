require 'rubygems'
require 'bundler/setup'
require 'selenium-cucumber'
require 'yaml'
require 'colorize'

# Do Not Remove This File
# Add your custom steps here
# $driver is instance of webdriver use this instance to write your custom code

When(/^I connect to websocket and subscribe to "([^"]*)" channel$/) do |channel_name|
  # passing no argument to the method will insert SockJS client file to the header of webpage so that test js files with SockJS commands can work
  insert_js_to_page_header

  # inserting an appropriate test js file to the head of current webpage based on channel type value
  insert_js_to_page_header channel_name

  if channel_name == "atw"
    $values_from_ws = get_atw_values_from_ws
    #$units_from_ws # logic to read unit from ws pending as dev has to fix it
  else
    $values_from_ws = get_values_from_ws # add logic to read unit from ws as well
    #$units_from_ws # logic to read unit from ws pending as dev has to fix it
  end

  puts "Simulator is done pushing #{$values_from_ws.size} test objects and #{channel_name} of each object streamed over websocket is captured in array: #{$values_from_ws}"
end

# alternatively use (length|width|height|speed) if variable types are never going to be other than the defined ones
Then(/^the "([^"]*)" value from websocket for each object should be same as in source XML$/) do |variable|
  # reading same yaml file that the hook used to push test data for reading the XML file
  scenario_yaml_for_hook = "features/support/methods/yamls/hook_sims_config.yaml"
  sim_paths = YAML.load_file(scenario_yaml_for_hook) # scenario_yaml can be defined through the feature file
  # read source XML and store the oi of each test object for comparison with data in Cassandra DB later
  read_objectdata_vals = ReadXMLdata.new # Object of ReadXMLdata class defined in dacq_integration_test_methods.rb
  document = read_objectdata_vals.setup("#{sim_paths['systemdata_sim']['systemdata_input_xml_path']}")
  if variable == "length" || variable == "width" || variable == "height"
    size_unit_from_xml = read_objectdata_vals.fetch_val_by_xpath(document, "//objectdata//volumetric//size/@unit") # create xpath for desired value using this online tool - http://xmlgrid.net/xpath.html
    size_unit_from_xml_with_abbrv_fix = fix_unit_abbrv(size_unit_from_xml)
    if variable == "length"
      length_from_xml = read_objectdata_vals.fetch_val_by_xpath(document, "//objectdata//volumetric//size/@ole")
      compare_websocket_data_with_xml(length_from_xml,size_unit_from_xml_with_abbrv_fix,$values_from_ws,$units_from_ws)
    elsif variable == "width"
      width_from_xml = read_objectdata_vals.fetch_val_by_xpath(document, "//objectdata//volumetric//size/@owi")
      compare_websocket_data_with_xml(width_from_xml,size_unit_from_xml_with_abbrv_fix,$values_from_ws,$units_from_ws)
    elsif variable == "height"
      height_from_xml = read_objectdata_vals.fetch_val_by_xpath(document, "//objectdata//volumetric//size/@ohe")
      compare_websocket_data_with_xml(height_from_xml,size_unit_from_xml_with_abbrv_fix,$values_from_ws,$units_from_ws)
    end
  elsif variable == "speed"
    speed_unit_from_xml = read_objectdata_vals.fetch_val_by_xpath(document, "//objectdata//sorterstate//speed/@unit")
    speed_from_xml = read_objectdata_vals.fetch_val_by_xpath(document, "//objectdata//sorterstate//speed//value")
    speed_from_xml_in_meters_per_sec = convert_speed_to_meter_per_sec(speed_from_xml, speed_unit_from_xml)
    compare_websocket_data_with_xml(speed_from_xml_in_meters_per_sec,$values_from_ws)
  else
    puts "Please recheck step. Only \"length\", \"width\", \"height\" & \"speed\" can be used as valid variables in this step for now."
    raise TestCaseFailed, 'Incorrect variable specified in Step'
  end
end

Given(/^I push the test "([^"]*)" to simulators stated in configuration file "([^"]*)"$/) do |data_type,file_name|
	step %[I navigate to "#{$SELCUKE_TEST_IN_PROGRESS}"] # launching a default HTML webpage during non-ui tests
	scenario_yaml = "features/support/methods/yamls/" + "#{file_name}"
	sim_paths = YAML.load_file(scenario_yaml) # scenario_yaml can be defined through the feature file

	if data_type == "objectdata"
	  # push test objectdata via SOSA batch client simulator
    push_objectdata = PushSims.new # Object of PushSims class defined in dacq_integration_test_methods.rb
    push_objectdata.setup("#{sim_paths['systemdata_sim']['SOSA_simulator_path']}","#{sim_paths['systemdata_sim']['systemdata_input_xml_path']}","#{sim_paths['systemdata_sim']['systemdata_params']}","#{sim_paths['systemdata_sim']['systemdata_log_file_path']}")
    push_objectdata.teardown("#{sim_paths['systemdata_sim']['systemdata_log_file_path']}","#{sim_paths['systemdata_sim']['systemdata_log_closing_statement']}","#{sim_paths['systemdata_sim']['systemdata_connection_error_statement']}")

    # read source XML and store the oi of each test object for comparison with data in Cassandra DB later
    read_objectdata = ReadXMLdata.new # Object of ReadXMLdata class defined in dacq_integration_test_methods.rb
    document = read_objectdata.setup("#{sim_paths['systemdata_sim']['systemdata_input_xml_path']}")

    xpath = "//objectdata//general//timestamp" # create xpath for desired value using this online tool - http://xmlgrid.net/xpath.html
    $timestamps_from_xml = read_objectdata.fetch_val_by_xpath(document, xpath)
  elsif data_type == "heartbeatdata"
    # push test heartbeatdata via SOSA batch client simulator
    push_heartbeatdata = PushSims.new # Object of PushSims class defined in dacq_integration_test_methods.rb
    push_heartbeatdata.setup("#{sim_paths['systemdata_sim']['SOSA_simulator_path']}","#{sim_paths['systemdata_sim']['systemdata_input_xml_path']}","#{sim_paths['systemdata_sim']['systemdata_params']}","#{sim_paths['systemdata_sim']['systemdata_log_file_path']}")
    push_heartbeatdata.teardown("#{sim_paths['systemdata_sim']['systemdata_log_file_path']}","#{sim_paths['systemdata_sim']['systemdata_log_closing_statement']}","#{sim_paths['systemdata_sim']['systemdata_connection_error_statement']}")

    # read source XML and store the oi of each test object for comparison with data in Cassandra DB later
    read_heartbeatdata = ReadXMLdata.new # Object of ReadXMLdata class defined in dacq_integration_test_methods.rb
    document = read_objectdata.setup("#{sim_paths['systemdata_sim']['systemdata_input_xml_path']}")

    xpath = "//heartbeatdata//timestamp" # create xpath for desired value using this online tool - http://xmlgrid.net/xpath.html
    $timestamps_from_xml = read_objectdata.fetch_val_by_xpath(document, xpath)
  elsif data_type == "imagedata" # imagedata scenario is very different from objectdata and will be tackled in a separate story. Code inside this scenario is just a placeholder
    # push test imagedata via FTP Test client simulator
    push_imagedata = PushSims.new # Object of PushSims class defined in dacq_integration_test_methods.rb
    push_imagedata.setup("#{sim_paths['imagedata_sim']['FTP_simulator_path']}","#{sim_paths['imagedata_sim']['imagedata_input_xml_path']}","#{sim_paths['imagedata_sim']['imagedata_params']}","#{sim_paths['imagedata_sim']['imagedata_log_file_path']}")
    push_imagedata.teardown("#{sim_paths['imagedata_sim']['imagedata_log_file_path']}","#{sim_paths['imagedata_sim']['imagedata_log_closing_statement']}","#{sim_paths['imagedata_sim']['imagedata_connection_error_statement']}")

    # read source XML and store the oi of each test object for comparison with data in Cassandra DB later
    read_imagedata = ReadXMLdata.new # Object of class defined in dacq_integration_test_methods.rb
    read_imagedata.setup("#{sim_paths['imagedata_sim']['imagedata_input_xml_path']}")

    # write some logic here to read a unique value of the source image for comparison later with the same param's value in Cassandra DB
  else
    puts "Only objectdata, heartbeatdata and imagedata can be defined as data types for now."
    raise TestCaseFailed, 'Incorrect data type specified in Step'
  end
end

When(/^I query objects for "([^"]*)" (.+) in table "([^"]*)" under keyspace "([^"]*)" of Cassandra DB's "([^"]*)" instance$/) do |primary_key,system_name,table_name,keyspace_name,ip_address|
  # objects of class defined in dacq_integration_test_methods.rb
  $query_objectdata = QueryCassandra.new # Object of class defined in query_cassandra.rb

  # establish a connection with Cassandra DB for querying
  $query_objectdata.setup(keyspace_name,ip_address)

  # calling a custom function that will allow to make queries with timestamp of data type string as converting to data type time is causing issues in time format
  $query_objectdata.create_custom_function

  $db_schema_val = Hash["key" => primary_key, "system" => system_name, "table" => table_name, "keyspace" => keyspace_name, "ip" => ip_address]

end

# -- temp: still figuring out a query for raw_data column with just timestamp
When(/^I query table "([^"]*)" under keyspace "([^"]*)" of Cassandra DB's "([^"]*)" instance$/) do |table_name,keyspace_name,ip_address|
  @pending
end

Then(/^I should see the test data getting recorded in that database$/) do
  # define the query statement
  prepared_query_statement = 'select count(*) from %{table} where %{key} = \'%{system}\' and object_scan_time = timefstring(?)' % {key: $db_schema_val['key'], table: $db_schema_val['table'], system: $db_schema_val['system']}

  # define the delete statement
  prepared_delete_statement = 'delete from %{table} where %{key} = \'%{system}\' and object_scan_time = timefstring(?)' % {key: $db_schema_val['key'], table: $db_schema_val['table'], system: $db_schema_val['system']}

  # query each object read from XML by its system & timestamp and print results
  for i in 0..$timestamps_from_xml.size - 1
    object_scan_time = $timestamps_from_xml[i].tr('T', ' ')
    query_results = $query_objectdata.query_statement(prepared_query_statement, object_scan_time)
    query_results.each do |row|
        if row['count'] == 1
          puts "Object from XML with timestamp: \"#{object_scan_time}\" was stored in DB by DACQ."#.green
          $query_objectdata.query_statement(prepared_delete_statement, object_scan_time)
        elsif row['count'] > 1
          puts "Total count of objectdata rows returned by query are: #{row['count']}"#.red
          raise TestCaseFailed, "Query for an object in XML with timestamp: \"#{object_scan_time}\" yielded more than one result from DB"
        else
          puts "Query returned Zero rows of objectdata"#.red
          raise TestCaseFailed, "Query for an object in XML with timestamp: \"#{object_scan_time}\" failed to yield any result from DB"
        end
    end
  end
  # close connection with Cassandra host
  $query_objectdata.teardown
  puts "Test objectdata from XML pushed via simulator matches with test data stored in Cassandra DB."#.cyan
  puts "\nAlso cleaned up test data pushed via sims to Cassandra DB to avoid any false positives in automated regression test results..."#.cyan
end