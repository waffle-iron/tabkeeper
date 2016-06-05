# == Schema Information
#
# Table name: materials
#
#  id         :integer          not null, primary key
#  song_id    :integer
#  title      :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

require 'test_helper'

class MaterialTest < ActiveSupport::TestCase
  test 'change youtube url to embedded url' do
    my_artist = Artist.create! name: 'Linkin Park'
    my_song = Song.find_or_create_by! name: 'Numb', artist: my_artist
    my_material = Material.find_or_create_by! url: 'https://www.youtube.com/watch?v=kXYiU_JCYtU'

    assert_not_nil my_material
    assert_includes my_song.materials, my_material

    expected_url = 'https://www.youtube.com/embed/kXYiU_JCYtU'

    assert_equal expected_url, my_material.url
    assert_equal 'video', my_material.kind
  end

end
