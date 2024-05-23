class VideosController < ApplicationController
  def google_oauth2_callback
    # Handle the callback from YouTube OAuth2 authorization
    authorization_code = params[:code]
    scope = params[:scope]
    google_account = GoogleAccount.first
    if google_account.access_token.nil?
      account = Yt::Account.new authorization_code:, redirect_uri: ENV['GOOGLE_OAUTH2_CALLBACK_URL']
      google_account.update(access_token: account.access_token, refresh_token: account.refresh_token)
    else
      account = Yt::Account.new access_token: google_account.access_token
    end

    uploaded_videos = []
    Video.downloaded_but_not_uploaded.each do |v|
      upload = account.upload_video v.download_directory, title: v.title, description: v.gospel, privacy_status: 'public'
      youtube_id = upload.id
      youtube_thumbnail = upload.snippet.data['thumbnails']['default']['url']
      if v.update(youtube_id:, youtube_thumbnail:, is_uploaded: true)
        service = Videos::UpdatePresentationService.new(video: v)
        service.perform
      end
      uploaded_videos << { youtube_id:, youtube_thumbnail:, presentation_id: v.presentation_id }
      puts "Video for presentation_id: #{v.presentation_id} updated in the database(youtube_id: #{youtube_id}, youtube_thumbnail: #{youtube_thumbnail}, is_uploaded: true)"
    end

    render json: { total_videos_uploaded: uploaded_videos.size, uploaded_videos: }
  end
end
