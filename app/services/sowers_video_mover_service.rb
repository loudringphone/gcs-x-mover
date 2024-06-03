class SowersVideoMoverService
  require "x"
  require "x/media_uploader"
  def perform
    url ="#{ENV['PRODUCTION_HOST']}/api/presentations/get_videos_for_completed_missions_without_tweet_ids?api_key=#{ENV['SOWERS_API']}"
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

    Video.not_downloaded.each do |video|
      file_path = Videos::DownloaderService.new(video).download
      if file_path
        video.update(download_directory: file_path, is_downloaded: true)
        puts "Video for presentation_id: #{video.presentation_id} updated in the database(is_downloaded: true)"
      else
        puts "Failed to download video for presentation_id: #{video.presentation_id}. Shutting down the server..."
        Rails.logger.error("Failed to download video for presentation_id: #{video.presentation_id}. Shutting down the server...")
        exit(1)
      end
    end
    Video.downloaded_not_splitted.each do |video|
      video_splitter = VideoSplitter.new(video:)
      video_splitter.split_video
    end

    Video.splitted_not_uploaded.each do |video|
      splitted_files = video.splitted_files
      puts "Start uploading splitted files for presentation_id: #{video.presentation_id}"
      splitted_files.each_with_index do |splitted_file, i|
        next if video.tweet_ids.size > i

        x_uploader = Videos::XUploaderService.new(file_path: splitted_file, text: video.title + " - Part #{i+1}")
        tweet_id = x_uploader.upload
        video.update(tweet_ids: video.tweet_ids + [tweet_id])
      end
      video.reload
      puts "Start sending data for presention_id: #{video.presentation_id} to Sowers database..."
      Videos::UpdatePresentationService.new(video:).perform
      video.update(is_uploaded: true)
    end
  end
end