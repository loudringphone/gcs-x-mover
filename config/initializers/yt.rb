Yt.configure do |config|
  google_client_secret = JSON.parse(ENV['GOOGLE_CLIENT_SECRET'])["web"]
  config.client_id = google_client_secret["client_id"]
  config.client_secret = google_client_secret["client_secret"]
end