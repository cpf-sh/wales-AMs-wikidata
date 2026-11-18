#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'wikidata/fetcher'

USER_AGENT="wikidata-wales-ams-fetcher (loudspeek@poteris.co.uk)"

module RestClient::Platform
  def self.default_user_agent
    USER_AGENT
  end
end

module OpenURI
  class << self
    alias open_uri_original_open_loop open_loop # :nodoc:
  end
  def OpenURI.open_loop(uri, options)
    open_uri_original_open_loop uri, options.merge({"User-Agent" => USER_AGENT})
  end
end

query = 'SELECT DISTINCT ?item { ?item wdt:P39/wdt:P279* wd:Q3406079 }'
ids = EveryPolitician::Wikidata.sparql(query)

EveryPolitician::Wikidata.scrape_wikidata(ids: ids)
