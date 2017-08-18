require 'rubygems'

# Do Not Remove This File
# This file contains assertion methods which are called from system_config_api_test_steps.rb

# Method to convert string to hash
# Usage example:
# > str = '0-20:100.25,28:200.1,29:100'
# string_to_hash(str)
# => {"0-20"=>"100.25", "28"=>"200.1", "29"=>"100"}
def string_to_hash(str, arr_sep=',', key_sep=':')
  array = str.split(arr_sep)
  hash = {}
  array.each do |e|
    key_value = e.split(key_sep)
    hash[key_value[0]] = key_value[1]
  end
  return hash
end

# Method to convert string with , and : separators to a nested array
def string_to_nested_array(str)
  arr1 = str.split(',')
  arr2 = []
  for i in 0..arr1.size - 1
    arr2[i] = arr1[i].split(':')
  end
  return arr2
end

# Method to prepare a formatted query for inserting multiple conditions
def multiple_conditions_insert_query_format(conditions_with_names_and_levels)
  seprated_conditions_with_seprated_level = string_to_nested_array(conditions_with_names_and_levels)

  olc_conditions = "'OLC' : { "
  blc_conditions = "'BLC' : { "

  for i in 0..seprated_conditions_with_seprated_level.size - 1
    if seprated_conditions_with_seprated_level[i][0] == "OLC"
      olc_conditions = olc_conditions + " '#{seprated_conditions_with_seprated_level[i][1]}' : ('#{seprated_conditions_with_seprated_level[i][1]}', '#{seprated_conditions_with_seprated_level[i][0]}', toTimestamp(now()), toTimestamp(now())),"
    elsif seprated_conditions_with_seprated_level[i][0] == "BLC"
      blc_conditions = blc_conditions + " '#{seprated_conditions_with_seprated_level[i][1]}' : ('#{seprated_conditions_with_seprated_level[i][1]}', '#{seprated_conditions_with_seprated_level[i][0]}', toTimestamp(now()), toTimestamp(now())),"
    end
  end
  formatted_query = olc_conditions[0..-2].insert(-1, ' }, ') + blc_conditions[0..-2].insert(-1, ' }')
  return formatted_query
end

# Method to prepare a formatted query for inserting multiple statistics
def multiple_statistics_insert_query_format(conditions_with_names_and_levels,statistics_with_conditions,statistics_with_exp_sys_rr)
  # converting string to nested arrays
  seprated_conditions_with_seprated_level = string_to_nested_array(conditions_with_names_and_levels)
  seprated_statistics_with_seprated_read_rates = string_to_nested_array(statistics_with_exp_sys_rr)

  # converting string to hash
  statistics_with_associated_conditions = string_to_hash(statistics_with_conditions)

  olc_statistics = "'OLC' : { "
  blc_statistics = "'BLC' : { "

  for i in 0..seprated_conditions_with_seprated_level.size - 1
    if seprated_conditions_with_seprated_level[i][0] == "OLC"
    olc_statistics = olc_statistics + " '#{seprated_conditions_with_seprated_level[i][1]}' : { "
    for j in 0..seprated_statistics_with_seprated_read_rates.size - 1
      if seprated_conditions_with_seprated_level[i][1] == statistics_with_associated_conditions[seprated_statistics_with_seprated_read_rates[j][0]]
      olc_statistics = olc_statistics + " '#{seprated_statistics_with_seprated_read_rates[j][0]}' : ('#{seprated_statistics_with_seprated_read_rates[j][0]}', ('#{seprated_conditions_with_seprated_level[i][1]}', '#{seprated_conditions_with_seprated_level[i][0]}', toTimestamp(now()), toTimestamp(now())), #{seprated_statistics_with_seprated_read_rates[j][1]}, toTimestamp(now()), toTimestamp(now())),"
    end
    end
    olc_statistics = olc_statistics[0..-2].insert(-1, ' }, ')
  elsif seprated_conditions_with_seprated_level[i][0] == "BLC"
    blc_statistics = blc_statistics + " '#{seprated_conditions_with_seprated_level[i][1]}' : { "
    for j in 0..seprated_statistics_with_seprated_read_rates.size - 1
      if seprated_conditions_with_seprated_level[i][1] == statistics_with_associated_conditions[seprated_statistics_with_seprated_read_rates[j][0]]
      blc_statistics = blc_statistics + " '#{seprated_statistics_with_seprated_read_rates[j][0]}' : ('#{seprated_statistics_with_seprated_read_rates[j][0]}', ('#{seprated_conditions_with_seprated_level[i][1]}', '#{seprated_conditions_with_seprated_level[i][0]}', toTimestamp(now()), toTimestamp(now())), #{seprated_statistics_with_seprated_read_rates[j][1]}, toTimestamp(now()), toTimestamp(now())),"
    end
    end
    blc_statistics = blc_statistics[0..-2].insert(-1, ' }, ')
    end
  end
  formatted_query = olc_statistics[0..-3].insert(-1, ' }, ') + blc_statistics[0..-3].insert(-1, ' }')
  return formatted_query
end


# Method to prepare a formatted query for assigned devices under the main query for inserting groups
def assigned_devices_to_group_insert_query_format(assigned_devices)
  devices = []
  devices = assigned_devices.split(',')
  for i in 0..devices.size - 1
    devices[i] = devices[i].to_s.gsub(':', '\' : \'').insert(0, '\'').insert(-1, '\'')
  end
  assigned_devices = devices.join(", ")
  return assigned_devices
end

# Method to prepare a formatted query for assigned statistics under the main query for inserting groups
def assigned_statistics_to_group_insert_query_format(group_expected_readrates,assigned_statistics)
  statistics = []
  statnames = []
  statistics = assigned_statistics.split(',')
  for i in 0..statistics.size - 1
    statnames[i] = statistics[i].split(':').last
    exp_rr_val = group_expected_readrates[statnames[i]]
    statistics[i] = statistics[i].to_s.gsub(':', '\' : {\'').insert(0, '\'').insert(-1, '\' : ').insert(-1, exp_rr_val).insert(-1, ' }')
  end
  assigned_statistics = statistics.join(", ")
end