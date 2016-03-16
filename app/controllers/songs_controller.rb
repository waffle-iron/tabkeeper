class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy, :index, :new, :create]

  # GET /songs
  # GET /songs.json
  def index
    unless @playlist.nil?
      @songs = @playlist.songs.order(:name) unless @playlist.nil?
      @title = @playlist.name unless @playlist.nil?
    end

    unless params[:q].nil?
      @songs = Song.search(params[:q])
      @title = "Results for #{params[:q]}"
    end

    if @songs.nil?
      @songs = Song.all
      @title = "All available songs"
    end

  end

  # GET /songs/1
  # GET /songs/1.json
  def show
    @materials = @song.materials

    @related_songs = @song.related_songs

    begin
      engine = CustomSearchEngine.new
      @google_search_results = engine.fetch_results "#{@song.name} #{@song.artist.name}"
    rescue Google::Apis::ClientError => error
      puts error.message
    end


  end


  # GET /songs/new
  def new

    @song = Song.new
    @artist = Artist.new

    unless params[:spotify_track_id].nil?
      # todo: this is very ugly
      @song = Song.new :spotify_track_id => params[:spotify_track_id] unless params[:spotify_track_id].nil?

      spotify_track = @song.spotify_track

      @artist = Artist.find_or_create_by(name: spotify_track.artists.first.name)

      @song = Song.find_or_create_by spotify_track_id: params[:spotify_track_id],
                                     artist: @artist,
                                     name: spotify_track.name, spotify_url: spotify_track.uri

    end


  end

  # GET /songs/1/edit
  def edit
  end

  # POST /songs
  # POST /songs.json
  def create
    if song_params[:spotify_track_id]
      @artist = Artist.find_or_create_by(name: spotify_track.artists.first.name)
      @song = Song.find_or_create_by spotify_track_id: song_params[:spotify_track_id],
                                     artist: @artist,
                                     name: spotify_track.name, spotify_url: spotify_track.uri
    else
      @artist = Artist.find_or_create_by name: artist_params[:name]
      @song = Song.find_or_create_by name: song_params[:name], artist: @artist
    end

    unless song_params['playlist_ids'].nil?
      song_params['playlist_ids'].each { |id| PlaylistsSongs.find_or_create_by song: @song, playlist_id: id }
    end


    #

    respond_to do |format|
      if @song.save
        format.html { redirect_to song_path(@song), notice: 'Song was successfully created.' }
        format.json { render :show, status: :created, location: @song }
      else
        format.html { render :new }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to @song, notice: 'Song was successfully updated.' }
        format.json { render :show, status: :ok, location: @song }
      else
        format.html { render :edit }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_url, notice: 'Song was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def sync_spotify
    # if @spotify_user
    #   @playlist = @spotify_user.playlists.select { |playlist| playlist.name == '<3' }.first
    #
    #   if !@playlist
    #     @playlist = @spotify_user.playlists.third
    #   end
    #
    #   @playlist.tracks.each do |track|
    #
    #     artist = Artist.find_or_create_by name: track.artists.first.name
    #
    #     song = Song.find_or_initialize_by spotify_track_id: track.id, spotify_url: track.uri, name: track.name, artist: artist
    #
    #     binding.pry
    #
    #     if song.new_record?
    #       song.save!
    #       SongsWorker.perform_async(song.id, current_user.id)
    #     end
    #
    #     SongsUsers.find_or_create_by user: current_user, song: song
    #
    #   end
    #
    #   redirect_to songs_url, notice: 'Successfully synced with Spotify.'
    # else
    #   redirect_to songs_url, error: 'Spotify user not found.'
    # end

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_song
    @playlist = Playlist.find(params[:playlist_id]) if params[:playlist_id]
    @song = Song.find(params[:id]) if params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def song_params
    params[:song].permit(
        :name,
        :spotify_track_id,
        :spotify_url,
        :artist_id,
        {:playlist_ids => []}
    )
  end

  def artist_params
    params[:artist].permit(
        :name,
        :artist_id
    )
  end

end
