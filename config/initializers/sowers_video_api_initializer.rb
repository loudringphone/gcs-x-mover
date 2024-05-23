if defined?(Rails::Server)
  Rails.application.config.to_prepare do
    SowersVideoApiService.new.get_videos_for_completed_missions
    google_account = GoogleAccount.first
    if google_account
      google_account.update(access_token: nil, refresh_token: nil)
    else
      google_account = GoogleAccount.create
      google_account.save
    end
  end
end