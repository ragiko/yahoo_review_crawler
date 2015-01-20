# coding: utf-8

require 'open-uri'
require 'json'
require 'pp'
require 'digest/sha2'

# 詳しくはここをみてね
# http://developer.yahoo.co.jp/webapi/shopping/shopping/v1/reviewsearch.html
# items = []

def filename
  t = Time.now.instance_eval { '%s.%03d' % [strftime('%Y/%m/%d %H:%M:%S'), (usec / 1000.0).round] }
  Digest::SHA256.hexdigest t
end

1000.downto(1) do |i|
  p "page #{i}"

  url = "http://shopping.yahooapis.jp/ShoppingWebService/V1/json/reviewSearch?appid=dj0zaiZpPXFrZDJhdTBZU3JnUSZzPWNvbnN1bWVyc2VjcmV0Jng9ZWI-&category_id=1&results=50&start=#{i}"
  res = open(url)
  code, message = res.status # res.status => ["200", "OK"]

  if code != '200'
    puts "OMG!! #{code} #{message}"
  end

  result = JSON.parse(res.read)

  if result["ResultSet"]["totalResultsAvailable"] == "0"
    puts "OMG!! #{i} データなし"
  end

  items = []

  result["ResultSet"]["Result"].each do |item|
    h = {
      title: item["ReviewTitle"],
      body: item["Description"],
      rate: item["Ratings"]["Rate"]
    }
    items << h
  end

  File.write("data/p#{i}.json", items.to_json)

  sleep(1.2)
end


