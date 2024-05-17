if defined?(Rails::Server)
  Rails.application.config.to_prepare do
    SowersVideoApiService.new.get_videos_for_completed_missions
  end
end