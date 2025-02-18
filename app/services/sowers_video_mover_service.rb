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
      end
    else
      raise "Error fetching data: #{response.code} - #{response.message}"
    end

    puts "\e[33mStarting to update #{Video.uploaded_not_db_updated.count} presentation(s) on Sowers database\e[0m"
    puts ""
    Video.uploaded_not_db_updated.each do |video|
      puts "Start sending data for presention_id: #{video.presentation_id} to Sowers database..."
      Videos::UpdatePresentationService.new(video:).perform
      video.update(is_db_updated: true)
    end

    puts "\e[33mStarting to upload #{Video.splitted_not_uploaded.count} split videos to X\e[0m"
    puts ""
    Video.splitted_not_uploaded.each do |video|
      splitted_files = video.splitted_files
      puts "Start uploading splitted files for presentation_id: #{video.presentation_id}"
      title = video.title
      mission_id = video.mission_id
      splitted_files.each_with_index do |splitted_file, i|
        next if video.tweet_ids.size > i

        text = title + " - Part #{i+1}\n" + "Check this out: #{ENV['PRODUCTION_HOST']}/missions/#{mission_id}"
        x_uploader = Videos::XUploaderService.new(file_path: splitted_file, text:)
        tweet_id = x_uploader.upload
        video.update(tweet_ids: video.tweet_ids + [tweet_id])
      end
      video.reload
      video.update(is_uploaded: true)
    end

    puts "\e[33mStarting to split #{Video.downloaded_not_splitted.count} downloaded videos on the local drive\e[0m"
    puts ""
    Video.downloaded_not_splitted.each do |video|
      video_splitter = VideoSplitter.new(video:)
      video_splitter.split_video
    end

    puts "\e[33mStarting to download #{Video.not_downloaded.count} video(s) from Google Cloud\e[0m"
    puts ""
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

    puts "\e[32mAll videos have been processed.\e[0m"
    puts ""
    puts "⏳ Waiting 1 hour before running again..."
    sleep(3600)
    perform
  end
end