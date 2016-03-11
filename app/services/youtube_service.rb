class MyYoutubeService
  def initialize(params)
    @artist = params[:artist]
    @song = params[:song]
  end

  def videos
    client, youtube = service_client

    # Call the search.list method to retrieve results matching the specified
    # query term.
    search_response = client.execute!(
        :api_method => youtube.search.list,
        :parameters => video_search_attributes
    )

    videos = []

    # Add each result to the appropriate list, and then display the lists of
    # matching videos, channels, and playlists.
    search_response.data.items.each do |search_result|
      videos << {
          title: search_result.snippet.title,
          id: search_result.id.videoId,
          published_at: search_result.snippet.publishedAt,
          url: "http://www.youtube.com/embed/#{search_result.id.videoId}"
      }
    end
    videos
  end

  private

  attr_reader :artist, :song

  def video_search_attributes
    {
        :part => 'snippet',
        :q => "#{song} #{artist} Guitar Tutorial",
        :maxResults => 3,
        :type => 'video',
        :order => 'relevance'
    }
  end

  DEVELOPER_KEY = 'AIzaSyDaFZsrBWmKjSuxmb_8F6gW-A9Za3F38nA'
  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'

  def service_client
    require 'google/apis/youtube_v3'

    youtube = Google::Apis::YoutubeV3::new

    youtube.key = DEVELOPER_KEY

    client = Google::APIClient.new(
        :key => DEVELOPER_KEY,
        :authorization => nil,
        :application_name => $PROGRAM_NAME,
        :application_version => '1.0.0'
    )
    youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

    return client, youtube
  end
end