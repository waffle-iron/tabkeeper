class HomeController < ApplicationController
  def index
    if @spotify_user
      redirect_to playlists_url and return
    end
  end
  def get

  end
end
