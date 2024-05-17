module Videos
  class CreateOrUpdate
    attr_reader :video_params
    def initialize(video_params)
      @video_params = video_params
    end

    def perform
      video = Video.find_or_create_by(
        presentation_id: video_params['presentation_id']
      ) do |v|
        v.assign_attributes(video_params)
      end
      video.persisted?
    end
  end
end