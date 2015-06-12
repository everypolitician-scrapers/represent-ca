
# Fetch Canadian Parliament information from https://scrapers.herokuapp.com/

require 'json'
require 'scraperwiki'
require 'open-uri'

def json_from(url)
  JSON.parse(open(url).read)
end

data = json_from('https://scrapers.herokuapp.com/represent/ca/').map do |m|
  {
    id: m['url'][/\((\d+)\)/, 1],
    name: m['name'],
    party: m['party_name'],
    party_id: m['party_name'].downcase.gsub(/\s+/,'_'),
    district: m['district_name'],
    website: m['personal_url'],
    email: m['email'],
    twitter: JSON.parse(m['extra'])['twitter'],
  }
end

data.each_with_index do |r, i|
  puts "Adding #{i+1}. #{r[:id]}: #{r}"
  ScraperWiki.save_sqlite([:id], data)
end
