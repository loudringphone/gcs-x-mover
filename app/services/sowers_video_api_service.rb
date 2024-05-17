class SowersVideoApiService
  include HTTParty

  def get_videos_for_completed_missions
    url ="#{ENV['PRODUCTION_HOST']}/api/presentations/get_videos_for_completed_missions_without_youtube_url?api_key=#{ENV['SOWERS_API']}"
    response = HTTParty.get(url)

    if response.success?
      videos = JSON.parse(response.body)
      videos.map do |video|
        service = Videos::CreateOrUpdate.new(video)
        if service.perform

        end
      end
    else
      raise "Error fetching data: #{response.code} - #{response.message}"
    end

    # binding.pry

  end
end