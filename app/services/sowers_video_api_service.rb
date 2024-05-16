class SowersVideoApiService
  include HTTParty
  base_uri "https://sowersworld.org/presentations/get_videos_for_completed_missions_without_youtube_url?api_key=#{ENV['SOWERS_API']}" # Replace with your API base URL

  def fetch_videos
    response = self.class.get('/videos') # Adjust the endpoint as per your API documentation
    if response.success?
      videos_data = JSON.parse(response.body)
      videos_data.each do |video_data|
        Video.create!(
          video_id: video_data['id'],
          video_url: video_data['url'],
          download_directory: 'path/to/download/directory' # Set the actual download directory here
        )
      end
    else
      # Handle API request failure
      Rails.logger.error("API request failed: #{response.code} - #{response.body}")
    end
  end
end