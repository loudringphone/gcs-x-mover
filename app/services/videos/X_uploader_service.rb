class Videos::XUploaderService
  attr_reader :account, :try, :file_path

  def initialize(account:, try:)
    @account = account
    @try = try

    desktop_path = File.join(Dir.home, 'Desktop')
    @file_path = File.join(desktop_path, 'Sowers', 'videos_uploaded.txt')
    unless File.exist?(@file_path)
      File.open(@file_path, 'w') {}
    end
  end

  def perform
    puts "Uploading videos to YouTube..."
    Video.downloaded_but_not_uploaded.each do |v|
      begin
        upload = account.upload_video v.download_directory, title: v.title, description: v.gospel, privacy_status: 'public'
        youtube_id = upload.id
        youtube_thumbnail = upload.snippet.data['thumbnails']['default']['url']
        if v.update(youtube_id:, youtube_thumbnail:, is_uploaded: true)
          service = Videos::UpdatePresentationService.new(video: v)
          service.perform
        end
        File.open(file_path, 'a') do |file|
          file.puts "youtube_id: #{youtube_id}, youtube_thumbnail: #{youtube_thumbnail}, presentation_id: #{v.presentation_id}"
        end
        puts "Video for presentation_id: #{v.presentation_id} updated in the database(youtube_id: #{youtube_id}, youtube_thumbnail: #{youtube_thumbnail}, is_uploaded: true)"
      rescue => e
        puts e.message
        error_code = e.response_body["error"]["code"]

        if error_code == 401
          youtube_upload_scope = 'youtube.upload'
          auth_url = Yt::Account.new(scopes: [youtube_upload_scope], redirect_uri: ENV['GOOGLE_OAUTH2_CALLBACK_URL']).authentication_url
          Launchy.open(auth_url)
        elsif error_code == 403
          try = try + 1
          google_client_secret = JSON.parse(ENV["GOOGLE_CLIENT_SECRET#{try}"])["web"]
          Yt.configure do |config|
            config.log_level = :debug
            config.client_id = google_client_secret["client_id"]
            config.client_secret = google_client_secret["client_secret"]
          end
          google_account = GoogleAccount.find_by(client_id: google_client_secret["client_id"])
          if google_account
            account = Yt::Account.new refresh_token: google_account.refresh_token
            Videos::YoutubeUploaderService.new(account:, try:).perform
          else
            youtube_upload_scope = 'youtube.upload'
            auth_url = Yt::Account.new(scopes: [youtube_upload_scope], redirect_uri: ENV['GOOGLE_OAUTH2_CALLBACK_URL']).authentication_url
            Launchy.open(auth_url)
          end
        end
      end
    end
  end
end