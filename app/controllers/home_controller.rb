class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    if @spotify_user
      redirect_to playlists_url and return
    end
  end
  def get

  end
end
