require 'test_helper'

class CustomSearchEngineTest < ActiveSupport::TestCase

  test 'search custom results' do
    google_search = CustomSearchEngine.new
    search_results = google_search.fetch_results 'Hello Adele'

    search_results.items.each do |item|
      assert_not_empty item.instance_variables
      assert_not_empty item.display_link
      assert_not_empty item.formatted_url
      assert_not_empty item.html_snippet
      assert_not_empty item.html_title
      assert_not_empty item.pagemap.inspect
      assert_not_empty item.snippet
      assert_not_empty item.title
    end


  end

end