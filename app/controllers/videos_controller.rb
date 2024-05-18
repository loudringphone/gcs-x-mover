class VideosController < ApplicationController
  def google_oauth2_callback
    # Handle the callback from YouTube OAuth2 authorization
    authorization_code = params[:code]
    scope = params[:scope]

    account = Yt::Account.new authorization_code:, redirect_uri: ENV['GOOGLE_OAUTH2_CALLBACK_URL']
    Video.downloaded_but_not_uploaded.each do |v|
      upload = account.upload_video v.download_directory, title: v.title, description: v.gospel, privacy_status: 'public'
      v.update(youtube_id: upload.id, is_uploaded: true)
    end










     #<Yt::Models::Video:0x000000010612d340
 @auth=
 #<Yt::Models::Account:0x0000000106121cc0
  @access_token=nil,
  @authentication=
   #<Yt::Models::Authentication:0x00000001051870d0
    @access_token=
     "ya29.a0AXooCgua1pS3YKNT3cBoaSGUUWc59E646sSySdBQX2H4qo2u3WdVtTeI5Adxs7MxZpZ7p94l1SJj-M0z4SoF3_o54YNxIQmcDzL6C4P7HcZl0JO1tYx1JQPcQz6ZRoqXlmYGs5RRj5iiq7Knw_lA08824grmB_Hl2dbBaCgYKAQsSARMSFQHGX2Mi3QSuExGmlwjKtDGQir8eVw0171",
    @error=nil,
    @expires_at=2024-05-18 20:08:23.084081 +1000,
    @refresh_token=
     "1//0gDuoABDcu7E9CgYIARAAGBASNwF-L9IrNeB2oDE3sICzCslu236i4spxYepcMmWWrCVndI2lT2QRCt-EDPO6ENo6AXlrlAj8mJs">,
  @authorization_code=
   "4/0AdLIrYf9i3FQcaBo3Pp6Dc-L6_IDo3lUp3V7exWc-eRQ3wUA_xNYe83sMJ_xuTcvAAe2iQ
",
  @device_code=nil,
  @expires_at=nil,
  @force=nil,
  @new_authentications=
   #<Yt::Collections::Authentications:0x00000001051ed100
    @auth=#<Yt::Models::Account:0x0000000106121cc0 ...>,
    @auth_params=
     {:client_id=>
       "790613386553-r0tqda08vj4608c26n18q3h0h70pu8e4.apps.googleusercontent.
com",
      :client_secret=>"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",
      :code=>
       "4/0AdLIrYf9i3FQcaBo3Pp6Dc-L6_IDo3lUp3V7exWc-eRQ3wUA_xNYe83sMJ_xuTcvAA
e2iQ",
      :redirect_uri=>
       "http://localhost:3000/videos/auth/google_oauth2/callback",
      :grant_type=>:authorization_code},
    @items=
     [#<Yt::Models::Authentication:0x00000001051870d0
       @access_token=
        "ya29.a0AXooCgua1pS3YKNT3cBoaSGUUWc59E646sSySdBQX2H4qo2u3WdVtTeI5Adxs
7MxZpZ7p94l1SJj-M0z4SoF3_o54YNxIQmcDzL6C4P7HcZl0JO1tYx1JQPcQz6ZRoqXlmYGs5RRj5i
iq7Knw_lA08824grmB_Hl2dbBaCgYKAQsSARMSFQHGX2Mi3QSuExGmlwjKtDGQir8eVw0171",
       @error=nil,
       @expires_at=2024-05-18 20:08:23.084081 +1000,
       @refresh_token=
        "1//0gDuoABDcu7E9CgYIARAAGBASNwF-L9IrNeB2oDE3sICzCslu236i4spxYepcMmWW
rCVndI2lT2QRCt-EDPO6ENo6AXlrlAj8mJs">],
    @last_index=1,
    @page_token=nil,
    @parent=#<Yt::Models::Account:0x0000000106121cc0 ...>>,
  @redirect_uri="http://localhost:3000/videos/auth/google_oauth2/callback",
  @refresh_token=nil,
  @resumable_sessions=
   #<Yt::Collections::ResumableSessions:0x000000010528f108
    @auth=#<Yt::Models::Account:0x0000000106121cc0 ...>,
    @headers=
     {"x-upload-content-length"=>299830275,
      "X-Upload-Content-Type"=>"video/*",
      "User-Agent"=>"Yt::Request (gzip)",
      "Authorization"=>
       "Bearer ya29.a0AXooCgua1pS3YKNT3cBoaSGUUWc59E646sSySdBQX2H4qo2u3WdVtTe
I5Adxs7MxZpZ7p94l1SJj-M0z4SoF3_o54YNxIQmcDzL6C4P7HcZl0JO1tYx1JQPcQz6ZRoqXlmYGs
5RRj5iiq7Knw_lA08824grmB_Hl2dbBaCgYKAQsSARMSFQHGX2Mi3QSuExGmlwjKtDGQir8eVw0171
"},
    @items=[],
    @parent=#<Yt::Models::Account:0x0000000106121cc0 ...>>,
  @scopes=nil>,
@id="dscEvV0ZWsI",
@snippet=
 #<Yt::Models::Snippet:0x0000000105657740
  @auth=nil,
  @data=
   {"publishedAt"=>"2024-05-18T09:08:25Z",
    "channelId"=>"UCIq-5WwK0CVsMGG0FGi75pA",
    "title"=>"28/Sowers Two Ways to Live in Indonesia by steve s. 1",
    "description"=>"Two Ways to Live",
    "thumbnails"=>
     {"default"=>
       {"url"=>"https://i.ytimg.com/vi/dscEvV0ZWsI/default.jpg",
        "width"=>120,
        "height"=>90},
      "medium"=>
       {"url"=>"https://i.ytimg.com/vi/dscEvV0ZWsI/mqdefault.jpg",
        "width"=>320,
        "height"=>180},
      "high"=>
       {"url"=>"https://i.ytimg.com/vi/dscEvV0ZWsI/hqdefault.jpg",
        "width"=>480,
        "height"=>360}},
    "channelTitle"=>"dollar gospel",
    "categoryId"=>"22",
    "liveBroadcastContent"=>"none",
    "localized"=>
     {"title"=>"28/Sowers Two Ways to Live in Indonesia by steve s. 1",
      "description"=>"Two Ways to Live"}}>>
  end
end
