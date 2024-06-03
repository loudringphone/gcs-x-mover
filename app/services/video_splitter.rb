# app/services/video_splitter.rb
require 'streamio-ffmpeg'

class VideoSplitter
  attr_reader :input_file, :output_directory, :duration, :splitted_files, :video, :mission_id, :presentation_id
  def initialize(video:)
    @input_file = video.download_directory
    desktop_path = File.join(Dir.home, 'Desktop')
    @mission_id = video.mission_id
    @presentation_id = video.presentation_id
    @output_directory = File.join(desktop_path, 'Sowers', @mission_id.to_s, @presentation_id.to_s)
    @duration = 140 # Duration in seconds for each segment
    @splitted_files = video.splitted_files
    @video = video
    FileUtils.mkdir_p(@output_directory) unless Dir.exist?(@output_directory)
  end

  def split_video
    begin
      movie = FFMPEG::Movie.new(input_file)
      total_seconds = movie.duration
      segments = (total_seconds / duration.to_f).ceil
      new_splitted_files = []
      puts "Splitting video into #{segments} segments"
      segments.times do |i|
        next if splitted_files.size > i

        if i.zero?
          filename = 'thumbnail.jpg'
          thumbnail_path = output_directory + '/' + filename
          thumbnail_options = { seek_time: 1, resolution: '124x94' }
          movie.screenshot(thumbnail_path, thumbnail_options)
          video.thumbnail.attach(io: File.open(thumbnail_path), filename:,key: "missions/#{mission_id}/#{presentation_id}/#{filename}")
        end
        start_time = i * duration
        output_file = File.join(output_directory, "output_#{i + 1}.mp4")
        options = { seek_time: start_time, duration: }
        movie.transcode(output_file, options)

        new_splitted_files << output_file
      end
        video.update!(is_splitted: true, splitted_files: video.splitted_files + new_splitted_files)


      puts "Video split and saved to #{@output_directory}"
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
      puts e.backtrace.join("\n")
    end
  end
end
