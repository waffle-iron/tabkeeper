class SongsWorker
  include Sidekiq::Worker
  # sidekiq_options retry: false

  def perform(song_id, user_id)
    song = Song.find(song_id)

    logger.info "working for song #{song.id}"

    harvest_songsterr(song)

    harvest_youtube(song)
  end

  def harvest_youtube(song)
    videos = YoutubeService.new({song: song.name, artist: song.artist.name}).videos

    videos.each do |v|
      Material.find_or_create_by url: v[:url], song: song, title: v[:title]
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
