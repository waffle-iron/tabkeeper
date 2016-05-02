# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  device_link_key        :string
#  spotify_info_hash      :text
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:spotify]

  has_many :materials

  before_create :generate_device_link_key

  has_many :login_attempts
  has_many :user_song_views, :dependent => :delete_all

  has_and_belongs_to_many :playlists

  serialize :spotify_info_hash, Hash

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image

      if auth.provider == 'spotify'
        spotify_user = RSpotify::User.new(auth)
        user.spotify_info_hash = spotify_user.to_hash
      end
    end


  end

  def generate_device_link_key
    self.device_link_key = SecureRandom.hex

    #TODO: make sure it's unique
  end

  def qr_code_device_link_key
    RQRCode::QRCode.new(self.device_link_key).as_html.html_safe
  end

end
