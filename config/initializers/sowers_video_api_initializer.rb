if defined?(Rails::Server)
  Rails.application.config.to_prepare do
    SowersVideoMoverService.new.perform
  end
end