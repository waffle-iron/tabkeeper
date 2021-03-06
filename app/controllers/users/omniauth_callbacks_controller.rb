module Users
  class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def spotify
      # in case a user was registered already and signed in but wants to link spotify now
      unless current_user.nil?
        spotify_user = RSpotify::User.new(request.env['omniauth.auth'])

        # persist user info
        current_user.provider = request.env['omniauth.auth']['provider']
        current_user.uid = request.env['omniauth.auth']['uid']
        current_user.spotify_info_hash = spotify_user.to_hash
        current_user.save!
        redirect_to select_spotify_playlists_url, notice: 'Spotify Linked'
        return
      end

      # create current user from omniauth data
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => 'Spotify') if is_navigational_format?
      else
        session['devise.spotify_data'] = request.env['omniauth.auth']
        redirect_to new_user_registration_url
      end
    end

    def failure
      redirect_to root_path
    end

  end
end
