require 'open-uri'
require 'fileutils'

class VideoDownloaderService
  attr_reader :mission_id, :cloud_url, :filename, :presentation_id
  def initialize(video)
    @mission_id = video.mission_id
    @cloud_url = video.cloud_url
    @filename = "#{video.title.gsub(' ', '_')}.mp4"
    @presentation_id = video.presentation_id
  end

  def download
    begin
      file_path = Rails.root.join('public', 'videos', filename)
      FileUtils.mkdir_p(File.dirname(file_path))
      puts "Downloading video for presentation_id: #{presentation_id}"
      URI.open(cloud_url) do |v|
        File.open(file_path, 'wb') do |file|
          file.write(v.read)
        end
      end
      puts "Downloaded video saved to #{file_path}"
      Rails.logger.info("Downloaded video saved to #{file_path}")
      file_path
    rescue => e
      Rails.logger.error("Failed to download video: #{e.message}")
      nil
    end
  end
end
