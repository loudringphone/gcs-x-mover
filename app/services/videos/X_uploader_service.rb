require 'open-uri'
require 'fileutils'

class Videos::XUploaderService
  attr_reader :file_path, :text
  def initialize(file_path:, text:)
    @file_path = file_path
    @text = text
  end

  def upload
    x_credentials = {
      api_key:             ENV["X_API_KEY"],
      api_key_secret:      ENV["X_API_KEY_SECRET"],
      access_token:        ENV["X_ACCESS_TOKEN"],
      access_token_secret: ENV["X_ACCESS_TOKEN_SECRET"],
    }
    begin
    client = X::Client.new(**x_credentials)
    media_category = "tweet_video"
    media = X::MediaUploader.chunked_upload(client:, file_path:, media_category:)
    X::MediaUploader.await_processing(client:, media:)
    tweet_body = {text: , media: {media_ids: [media["media_id_string"]]}}
    tweet = client.post("tweets", tweet_body.to_json)
    tweet_id = tweet["data"]["id"]
    puts "tweet_id: #{tweet_id}"
    tweet_id
    rescue => e
      Rails.logger.error("Failed to upload video: #{e.message}")
      nil
    end
  end
end
