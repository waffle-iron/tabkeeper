# == Schema Information
#
# Table name: songs
#
#  id         :integer          not null, primary key
#  name       :string
#  url        :string
#  genre_id   :integer
#  difficulty :integer
#  artist_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Song < ActiveRecord::Base
  belongs_to :genre
  belongs_to :artist
  has_and_belongs_to_many :users

  # validates :artist, presence: true
  # validates :url, uniqueness: true

  after_create :harvest_song_url

  def harvest_song_url
    SongsWorker.perform_async(self.id)
  end
end