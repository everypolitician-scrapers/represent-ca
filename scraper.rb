# Fetch Canadian Parliament information from https://scrapers.herokuapp.com/

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
    image: m['photo_url'],
    website: m['personal_url'],
    email: m['email'],
    twitter: JSON.parse(m['extra'])['twitter'],
  }
end

ScraperWiki.sqliteexecute('DROP TABLE data') rescue nil
ScraperWiki.save_sqlite([:id], data)
