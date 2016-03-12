require 'test_helper'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

class SongsWorkerTest < ActiveSupport::TestCase

  test "harvest" do

    my_artist = Artist.find_or_create_by! name: 'Red Hot Chili Peppers'
    song = Song.find_or_create_by! name: 'Dani California', artist: my_artist


    # delete all material first, have clean slate
    song.materials.each { |m| m.destroy }

    # assert_empty song.materials

    Sidekiq::Testing.inline! do
      worker = SongsWorker.new
      worker.harvest_google(song)
    end

    song = Song.find(song.id)

    assert_not_empty song.materials
    song.materials.each {|m| puts m.kind }
  end

end