class SongsWorker
  include Sidekiq::Worker
  # sidekiq_options retry: false

  def perform(song_id)
    song = Song.find(song_id)

    logger.info "working for song #{song.id}"

    harvest_google(song)
  end

  def harvest_google(song)
    google = CustomSearchEngine.new
    results = google.fetch_results("#{song.name} #{song.artist.name}").items.take(5)

    results.each do |res|
      Material.find_or_create_by url: res.link, song: song, title: res.title
    end
  end

end
