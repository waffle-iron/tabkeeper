# == Schema Information
#
# Table name: songs
#
#  id                :integer          not null, primary key
#  name              :string
#  genre_id          :integer
#  difficulty        :integer
#  artist_id         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  chord_text        :text
#  spotify_track_id  :string
#  spotify_url       :string
#  album_artwork_url :string
#

class Song < ActiveRecord::Base
  belongs_to :genre
  belongs_to :artist
  has_and_belongs_to_many :playlists
  has_many :materials, dependent: :destroy

  validates :artist, presence: true
  validates :spotify_track_id, uniqueness: true

  #fetch song from spotify
  def spotify_track
    Rails.cache.fetch("spotify_track/#{self.spotify_track_id}", expires_in: 12.hours) do
      RSpotify::Track.find(self.spotify_track_id)
    end
  end

  #finds related songs by artists, very random, very inaccurate
  def related_songs
    related_artists = self.spotify_track.artists.first.related_artists

    related_artists.shuffle[0..4].map do |artist|
      artist.top_tracks('IE').shuffle.first
    end.flatten
  end

  def self.search(pattern)
    if pattern.blank?  # blank? covers both nil and empty string
      all
    else
      wildcard_search = "%#{pattern}%"
      where('name ILIKE :search', search: wildcard_search)

    end
  end


  after_save :fetch_material

  protected
    def fetch_material
      SongsWorker.perform_async(self.id)
    end

end
