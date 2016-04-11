class UserSongView < ActiveRecord::Base
  belongs_to :user
  belongs_to :song

  validates :user, presence: true
  validates :song, presence: true
end
