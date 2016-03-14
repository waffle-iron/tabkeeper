class SongsWorker
  include Sidekiq::Worker
  # sidekiq_options retry: false

  def perform(song_id)
    song = Song.find(song_id)

    logger.info "working for song #{song.id}"

    harvest_google(song)

    harvest_songsterr(song)
  end

  def harvest_google(song)
    google = CustomSearchEngine.new
    results = google.fetch_results("#{song.name} #{song.artist.name}").items.take(5)

    results.each do |res|
      Material.find_or_create_by url: res.link, song: song, title: res.title
    end
  end

  def harvest_songsterr(song)
    songsterr_song = Songsterr::Song.where(:pattern => "#{song.name} #{song.artist.name}")

    if songsterr_song.first
      Material.find_or_create_by url: "http://www.songsterr.com/a/wa/song?id=#{songsterr_song.first.id}",
                                 song: song, title: "Songsterr Link for #{song.name}"
    end
  end

end
