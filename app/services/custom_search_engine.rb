class CustomSearchEngine

  DEVELOPER_KEY = 'AIzaSyBCqES1cUYuDwAFbYC9eoFCRM5DmXqftlQ'
  SEARCH_ENGINE_ID = '014796693518786479783:uo9ddumzfgo'

  attr_accessor :client

  def fetch_results(query)
    key = query.hash
    Rails.cache.fetch("#{key}/google_results", expires_in: 48.hours) do
      self.client.list_cses query, cx: SEARCH_ENGINE_ID
    end

  end

  def initialize
    require 'google/apis/customsearch_v1'

    client = Google::Apis::CustomsearchV1::CustomsearchService.new
    client.key= DEVELOPER_KEY

    self.client = client
  end
end