class ArtistsController < ApplicationController
  def index
    @artists = Artist.all
  end

  # GET /songs/1
  def show
    @artist = Artist.find(params[:id]) if params[:id]
  end
end
