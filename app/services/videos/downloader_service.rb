require 'open-uri'
require 'fileutils'

class Videos::DownloaderService
  attr_reader :cloud_url, :file_path
  def initialize(video)
    @cloud_url = video.cloud_url
    mission_id = video.mission_id
    presentation_id = video.presentation_id
    @filename = "#{presentation_id}.mp4"
    desktop_path = File.join(Dir.home, 'Desktop')
    @file_path = File.join(desktop_path, 'Sowers', "m_#{mission_id.to_s}", "p_#{presentation_id.to_s}", filename)
  end

  def download
    begin
      # desktop_path = case RUBY_PLATFORM
      # when /darwin/  # macOS
      #   File.join(Dir.home, 'Desktop')
      # when /win32|win64|cygwin/  # Windows
      #   File.join(Dir.home, 'Desktop')
      # else  # Assume Linux/Unix
      #   File.join(Dir.home, 'Desktop')
      # end

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
