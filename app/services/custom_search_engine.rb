class CustomSearchEngine

  DEVELOPER_KEY = 'AIzaSyBCqES1cUYuDwAFbYC9eoFCRM5DmXqftlQ'
  TABS_AND_CHORDS_SE_ID = '014796693518786479783:uo9ddumzfgo'
  YOUTUBE_SE_ID = '014796693518786479783:stwwlc0e6m8'

  attr_accessor :client

  def fetch_tabs_and_chords(query)
    fetch(query, TABS_AND_CHORDS_SE_ID)
  end

  def fetch_youtube_results(query)
    fetch(query, YOUTUBE_SE_ID)
  end

  def initialize
    require 'google/apis/customsearch_v1'

    client = Google::Apis::CustomsearchV1::CustomsearchService.new
    client.key= DEVELOPER_KEY

    self.client = client
  end

  private

  def fetch(query, search_engine_id)
    key = query.hash
    Rails.cache.fetch("#{key}/#{search_engine_id}/google_results", expires_in: 7.days) do
      self.client.list_cses query, cx: search_engine_id
    end
  end
end