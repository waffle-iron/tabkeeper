require 'test_helper'

class SpotifyServiceTest < ActiveSupport::TestCase

  test 'find by title and artist' do
    service = SpotifyService.new
    found = service.find_by title: 'Hello', artist: 'Adele'

    assert_equal 'Adele', found.artists.first.name
    assert_equal 'Hello', found.name
    assert_not_empty found.id
    assert_not_empty found.uri
    puts found.inspect
  end

end