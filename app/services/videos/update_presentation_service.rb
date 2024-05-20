class Videos::UpdatePresentationService
  include HTTParty
  base_uri ENV['PRODUCTION_HOST']

  attr_reader :presentation_id, :youtube_id, :youtube_thumbnail
  def initialize(video:)
    @presentation_id = video.presentation_id
    @youtube_id = video.youtube_id
    @youtube_thumbnail = video.youtube_thumbnail
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
    { youtube_id:, youtube_thumbnail: }
  end
end