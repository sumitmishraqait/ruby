require 'rest_client'
require "test/unit/assertions"
include Test::Unit::Assertions
require 'json'

url='http://10.0.18.108:8080/system/01/statistics/aggregatedreadrate/daily'
resp=RestClient.get(url)
@data  = JSON.parse(resp.body)
  puts"#{@data[0]['statistic'].keys}"

    puts"#{@data[0]['statistic']}"
      puts"#{@data[0]['statistic']['condition']}"
  puts"===================================="
    puts"#{@data[1].keys}"
      puts"===================================="
      puts"#{@data[2].keys}"
        puts"===================================="
        assert_equal(resp.code,200)
assert_equal(@data[0]['conditionName'],'T1T2')
assert_equal(@data[1]['conditionName'],'ValidRead')
assert_equal(@data[2]['conditionName'],'ValidWeight')
puts"assert successful"
