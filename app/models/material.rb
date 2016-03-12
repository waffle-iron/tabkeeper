# == Schema Information
#
# Table name: materials
#
#  id         :integer          not null, primary key
#  song_id    :integer
#  title      :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Material < ActiveRecord::Base
  belongs_to :song
  belongs_to :user

  KIND_VIDEO = 'video'
  KIND_CHORD = 'chord'

  TYPES = [KIND_VIDEO, KIND_CHORD]

  validates_inclusion_of :kind, :in => TYPES
  validates :url, uniqueness: true

  # Define a named scope for each state in TYPES
  scope :video, -> { where(kind: KIND_VIDEO) }
  scope :chord, -> { where(kind: KIND_CHORD) }

  before_validation :check_for_youtube, :check_for_chord

  def check_for_youtube
    if url.include? 'youtube'
      self.url = youtube_embedded_url(url) if url.include? 'youtube'
      self.kind = KIND_VIDEO
    end
  end

  def check_for_chord
    if url.include? 'songsterr' or url.include? 'ultimate-guitar'
      self.kind = KIND_CHORD
    end
  end

  def youtube_embedded_url(youtube_url)
    if youtube_url[/youtu\.be\/([^\?]*)/]
      youtube_id = $1
    else
      # Regex from # http://stackoverflow.com/questions/3452546/javascript-regex-how-to-get-youtube-video-id-from-url/4811367#4811367
      youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
      youtube_id = $5
    end

    "http://www.youtube.com/embed/#{ youtube_id }"
  end

end
