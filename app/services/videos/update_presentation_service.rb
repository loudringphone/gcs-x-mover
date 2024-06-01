class Videos::UpdatePresentationService
  include HTTParty
  base_uri ENV['PRODUCTION_HOST']

  attr_reader :presentation_id, :tweet_ids, :thumbnail_url
  def initialize(video:)
    @presentation_id = video.presentation_id
    @tweet_ids = video.tweet_ids
    mission_id = video.mission_id
    presentation_id = video.presentation_id
    @thumbnail_url = "https://storage.googleapis.com/#{ENV['GCLOUD_BUCKET']}/missions/#{mission_id}/#{presentation_id}/thumbnail.jpg" if video.thumbnail.attached?
  end

  def perform
    self.class.patch("/presentations/#{@presentation_id}",
    body: { presentation: presentation_params },
    headers: {
      'Authorization': "Bearer #{ENV['SOWERS_API']}"
    })
  end

  private

  def presentation_params
    { tweet_ids:, thumbnail_url: }
  end
end