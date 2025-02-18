class Videos::CreateOrUpdate
  attr_reader :video_params
  def initialize(video_params)
    @video_params = video_params
  end

  def perform
    base_title = "#{video_params['mission_id']}/#{video_params['creator_name'].gsub(' ', '')} #{video_params['gospel']} in #{video_params['country']} by #{video_params['assignee_name']}"
    title = generate_unique_title(base_title)

    video = Video.find_or_create_by(
      presentation_id: video_params['presentation_id']
    ) do |v|
      v.assign_attributes(video_params.except('presentation_id'))
      v.title = title
    end
    video.persisted?
  end

  private

  def generate_unique_title(base_title)
    counter = 1
    unique_title = "#{base_title} #{counter}"

    while Video.exists?(title: unique_title)
      counter += 1
      unique_title = "#{base_title} #{counter}"
    end

    unique_title
  end
end