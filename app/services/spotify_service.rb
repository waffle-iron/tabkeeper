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

  def get_user_playlists(user)
    spotify_user = setup_spotify_user(user)
    Rails.cache.fetch("spotify_playlists/#{spotify_user.hash}", expires_in: 24.hours) do
      spotify_playlists = spotify_user.playlists(limit: 50, offset: 0)

      if spotify_playlists.length == 50
        #get another batch so we support up to 100 playlists
        more_spotify_playlists = spotify_user.playlists(limit: 50, offset: 50)
        spotify_playlists = spotify_playlists.concat more_spotify_playlists
      end

      spotify_playlists
    end

  end

  private

  def setup_spotify_user(user)
    Rails.cache.fetch("spotify_user/#{user.id}", expires_in: 24.hours) do
      return RSpotify::User.new(user.spotify_info_hash) if user and user.spotify_info_hash and user.spotify_info_hash.length > 0
    end

  end

end