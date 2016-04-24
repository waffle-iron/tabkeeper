class ArtistsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  def index
    @artists = Artist.all
  end

  # GET /songs/1
  def show
    @artist = Artist.find(params[:id]) if params[:id]
  end
end
