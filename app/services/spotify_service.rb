class SpotifyService

  def find_by_id(id)
    Rails.cache.fetch("spotify_track/#{id}", expires_in: 12.days) do
      RSpotify::Track.find(id)
    end
  end

  def find_by(title:, artist:)

    query = "#{title}+#{artist}"
    Rails.cache.fetch("spotify_track/#{query}", expires_in: 24.hours) do
      results = RSpotify::Track.search(query)
      results.first unless results.nil?

    end
  end

  def initialize

  end
end