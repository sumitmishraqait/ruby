require 'selenium-cucumber'
require 'cucumber-rest-bdd'
require 'cucumber-api'

# Do Not Remove This File
# Add your custom steps here
# $driver is instance of webdriver use this instance to write your custom code

Given(/^I am testing a REST API$/) do
  step %[I navigate to "#{$SELCUKE_TEST_IN_PROGRESS}"] # launching a default HTML webpage during non-ui tests
end

Given(/^I reset system configuration of following server:$/) do |table|
  # convert table to a hash with each row as a key, value pair
  # (Note: hash of each column is a little bit complex and is explained here - https://stackoverflow.com/questions/19909912/cucumber-reading-data-from-a-3-column-table)
  db_info = table.rows_hash

  # temporarily store & use ip address var for add conditions step until Cassandra starts supporting inserting an object in map of a map
  @server_ip_address = db_info['ip_address']

  # Object of class defined in query_cassandra.rb
  @sys_config = QueryCassandra.new

  # establish a connection with Cassandra DB
  @sys_config.setup(db_info['keyspace'],db_info['ip_address'])

  # define the truncate statement
  prepared_truncate_statement = 'TRUNCATE %{key}.%{table}' % {key: db_info['keyspace'], table: db_info['table']}

  # execute the truncate statement via remote cqlsh
  @sys_config.execute_statement(prepared_truncate_statement)
end

Given(/^I clear the response cache$/) do
  # $cache is a global parameter used in cucumber-api gem's "steps.rb" file
  # if not cleared previously cached response is used instead of getting new response
  $cache = {}
end

Given(/^I add (a|another|multiple) new (system|condition|statistic|device|group) with following configuration:$/) do |arg, type, table|
  # convert table to a hash with each row as a key, value pair
  config = table.rows_hash
  if type == "system"
    # define the system insert statement
    prepared_insert_statement = 'insert into sick_il.system
    (facility_id, system_name, system_label, min_read_cycles, noread_threshold, moving_average_length, moving_average_warning_threshold, date_added, last_modified) values
    (\'%{facility_id}\', \'%{system_name}\', \'%{system_label}\', %{min_read_cycles}, %{noread_threshold}, %{moving_average_length}, %{moving_average_warning_threshold}, toTimestamp(now()), toTimestamp(now()));' % {facility_id: config['facilityId'], system_name: config['systemName'], system_label: config['systemLabel'], min_read_cycles: config['minReadCycles'], noread_threshold: config['noreadThreshold'], moving_average_length: config['movingAverageLength'], moving_average_warning_threshold: config['movingAverageWarningThreshold']}
  elsif type == "condition"
    if arg == "a" || arg == "another"
      # define the assigned condition insert statement if there are no existing conditions or if there is one OLC level condition and another BLC level condition is to be added and vice-versa for BLC to OLC
      prepared_insert_statement = 'update sick_il.system
      SET assigned_conditions = assigned_conditions + {\'%{condition_level}\' : {\'%{condition_name}\' : (\'%{condition_name}\', \'%{condition_level}\', toTimestamp(now()), toTimestamp(now()))}}
      where system_name = \'%{system_name}\' and facility_id = \'%{facility_id}\';' % {facility_id: config['facilityId'], system_name: config['systemName'], condition_name: config['conditionName'], condition_level: config['conditionLevel']}
    elsif arg == "multiple"
      # get a formatted query for multiple conditions from the string containing condition levels and names
      multiple_conditions_formatted_query = multiple_conditions_insert_query_format(config['conditionNameAndLevel'])

      # define the condition insert statement for multiple conditions
      prepared_insert_statement = 'update sick_il.system
      SET assigned_conditions = { %{insert_multiple_conditions} }
      where system_name = \'%{system_name}\' and facility_id = \'%{facility_id}\';' % {facility_id: config['facilityId'], system_name: config['systemName'], insert_multiple_conditions: multiple_conditions_formatted_query}
    end
  elsif type == "statistic"
    if arg == "a" || arg == "another"
      # define the assigned statistic insert statement if there are no existing statistics or if there is one statistic based on OLC level condition and another statistic based on BLC level condition is to be added and vice-versa BLC to OLC
      # define the assigned statistic insert statement
      if config['statisticType'] == "assigned"
        prepared_insert_statement = 'update sick_il.system
        SET assigned_statistics = assigned_statistics + {\'%{condition_level}\' : {\'%{condition_name}\' : {\'%{statistic_name}\' : (\'%{statistic_name}\', (\'%{condition_name}\', \'%{condition_level}\', toTimestamp(now()), toTimestamp(now())), %{system_exp_rr_val}, toTimestamp(now()), toTimestamp(now()))}}}
        where system_name = \'%{system_name}\' and facility_id = \'%{facility_id}\';' % {facility_id: config['facilityId'], system_name: config['systemName'], condition_name: config['conditionName'], condition_level: config['conditionLevel'], statistic_name: config['statisticName'], system_exp_rr_val: config['systemExpReadRate']}
      elsif config['statisticType'] == "primary"
        prepared_insert_statement = 'update sick_il.system
        SET primary_statistic = {stat_name : \'%{statistic_name}\', eval_condition : (\'%{condition_name}\', \'%{condition_level}\', toTimestamp(now()), toTimestamp(now())), threshold: %{system_exp_rr_val}, date_added: toTimestamp(now()), date_modified: toTimestamp(now())}
        where system_name = \'%{system_name}\' and facility_id = \'%{facility_id}\';' % {facility_id: config['facilityId'], system_name: config['systemName'], condition_name: config['conditionName'], condition_level: config['conditionLevel'], statistic_name: config['statisticName'], system_exp_rr_val: config['systemExpReadRate']}
      elsif config['statisticType'] == "secondary"
        prepared_insert_statement = 'update sick_il.system
        SET secondary_statistic = {stat_name : \'%{statistic_name}\', eval_condition : (\'%{condition_name}\', \'%{condition_level}\', toTimestamp(now()), toTimestamp(now())), threshold: %{system_exp_rr_val}, date_added: toTimestamp(now()), date_modified: toTimestamp(now())}
        where system_name = \'%{system_name}\' and facility_id = \'%{facility_id}\';' % {facility_id: config['facilityId'], system_name: config['systemName'], condition_name: config['conditionName'], condition_level: config['conditionLevel'], statistic_name: config['statisticName'], system_exp_rr_val: config['systemExpReadRate']}
      end
    elsif arg == "multiple"
      # get a formatted query for multiple statistics from the strings passed from data table
      multiple_statistics_formatted_query = multiple_statistics_insert_query_format(config['conditionNameAndLevel'],config['statisticNameAndCondition'],config['statisticNameAndsystemExpReadRate'])

      prepared_insert_statement = 'update sick_il.system
      SET assigned_statistics = { %{insert_multiple_statistics} }
      where system_name = \'%{system_name}\' and facility_id = \'%{facility_id}\';' % {facility_id: config['facilityId'], system_name: config['systemName'], insert_multiple_statistics: multiple_statistics_formatted_query}
    end
  elsif type == "device"
    # validate device type passed is one of device types allowed
    if !%w(LECTOR IPCam ICR CLV MSC/SIM VMS Other).include? config['deviceType']
      raise TestCaseFailed, "Device Type: \"#{config['deviceType']}\" is not in the list of allowed device types"
    else
      if config['deviceExpReadRate'] == "NULL"
        # define the device insert statement with device level expected read rate threshold not set for a match code statistic
        prepared_insert_statement = 'update sick_il.system
        SET assigned_devices = assigned_devices + {\'%{device_id}\' : (\'%{system_name}\', \'%{device_id}\', \'%{device_name}\', \'%{device_type}\', \'%{device_username}\', \'%{device_password}\', \'%{device_ip}\',  %{device_no_read_limit}, toTimestamp(now()), toTimestamp(now()), NULL)}
        where system_name = \'%{system_name}\' and facility_id = \'%{facility_id}\';' % {facility_id: config['facilityId'], system_name: config['systemName'], device_id: config['deviceId'], device_name: config['deviceName'], device_type: config['deviceType'], device_username: config['deviceUsername'], device_password: config['devicePassword'], device_ip: config['deviceIp'], device_no_read_limit: config['deviceNoReadLimit']}
      else
        # define the device insert statement with device level expected read rate threshold set for a match code statistic
        prepared_insert_statement = 'update sick_il.system
        SET assigned_devices = assigned_devices + {\'%{device_id}\' : (\'%{system_name}\', \'%{device_id}\', \'%{device_name}\', \'%{device_type}\', \'%{device_username}\', \'%{device_password}\', \'%{device_ip}\',  %{device_no_read_limit}, toTimestamp(now()), toTimestamp(now()), { \'%{condition_name}\' : { \'%{statistic_name}\' : %{device_exp_rr_val} }})}
        where system_name = \'%{system_name}\' and facility_id = \'%{facility_id}\';' % {facility_id: config['facilityId'], system_name: config['systemName'], device_id: config['deviceId'], device_name: config['deviceName'], device_type: config['deviceType'], device_username: config['deviceUsername'], device_password: config['devicePassword'], device_ip: config['deviceIp'], device_no_read_limit: config['deviceNoReadLimit'], condition_name: config['conditionName'], statistic_name: config['statisticName'], device_exp_rr_val: config['deviceExpReadRate']}
      end
    end
  elsif type == "group"

    # converting string to hash
    group_exp_rrs = string_to_hash(config['groupExpReadRate'])

    # preparing json insert statement for assigned devices
    config['assignedDevices'] = assigned_devices_to_group_insert_query_format(config['assignedDevices'])

    # preparing json insert statement for assigned statistics
    config['assignedStatistics'] = assigned_statistics_to_group_insert_query_format(group_exp_rrs,config['assignedStatistics'])

    # define the group insert statement with assigned devices and statistics
    prepared_insert_statement = 'update sick_il.system
    SET assigned_device_groups = assigned_device_groups + { \'%{group_name}\' : { device_group_name : \'%{group_name}\', noread_threshold : %{group_no_read_limit}, date_added : toTimestamp(now()), date_modified : toTimestamp(now()),
    assigned_devices : { %{assigned_devices} },
    assigned_statistics : { %{assigned_statistics} }}}
    where system_name = \'%{system_name}\' and facility_id = \'%{facility_id}\';' % {facility_id: config['facilityId'], system_name: config['systemName'], group_name: config['groupName'], group_no_read_limit: config['groupNoReadLimit'], assigned_devices: config['assignedDevices'], assigned_statistics: config['assignedStatistics']}
  end
  # execute the system insert statement via remote cqlsh if cql insertion is required
  @sys_config.execute_statement(prepared_insert_statement)
end