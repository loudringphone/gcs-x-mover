if defined?(Rails::Server)
  Rails.application.config.to_prepare do
    require_relative '../../app/services/sowers_video_api_service'
    require_relative '../../app/services/videos/create_or_update.rb'

    SowersVideoApiService.new.get_videos_for_completed_missions
  end
end