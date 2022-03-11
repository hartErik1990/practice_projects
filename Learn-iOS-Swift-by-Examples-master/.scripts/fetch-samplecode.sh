#!/bin/bash

curl 'https://developer.apple.com/search/search_data.php?q=swift%203&results=500' -s -e developer.apple.com -o /tmp/search_result.json

ruby -e "require 'json';
require 'csv';
CSV.open('samplecode.csv', 'wb') do |csv|
  JSON.parse(File.open('/tmp/search_result.json').read)['results'].keep_if {|v|
    v['type'] == 'sample_code'
  }.sort_by {|x| x['title']}.each{|sc|
    csv << [sc['url'].match('\/samplecode\/([^\/]*)\/')[1], 'https://developer.apple.com' + sc['url'] + 'Introduction/Intro.html', sc['title'], sc['date']]
  }
end
"
