class VideosController < ApplicationController
  def google_oauth2_callback
    authorization_code = params[:code]
    scope = params[:scope]
    account = Yt::Account.new authorization_code:, redirect_uri: ENV['GOOGLE_OAUTH2_CALLBACK_URL']
    yt_client_id = Yt.configuration.client_id
    google_account = GoogleAccount.find_by(client_id: yt_client_id)
    if google_account
      google_account.update(access_token: account.access_token, refresh_token: account.refresh_token)
    else
      google_account = GoogleAccount.create(access_token: account.access_token, refresh_token: account.refresh_token, client_id: yt_client_id)
    end

    case yt_client_id
    when JSON.parse(ENV["GOOGLE_CLIENT_SECRET1"])["web"]["client_id"]
      try = 1
    when JSON.parse(ENV["GOOGLE_CLIENT_SECRET2"])["web"]["client_id"]
      try = 2
    end
    Videos::YoutubeUploaderService.new(account:, try:).perform

    render head :ok
  end
end
