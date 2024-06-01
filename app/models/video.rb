class Video < ApplicationRecord
  has_one_attached :thumbnail

  scope :not_downloaded, -> { where(is_downloaded: false) }
  scope :downloaded_not_splitted, -> { where(is_downloaded: true, is_splitted: false) }
  scope :splitted_not_uploaded, -> { where(is_splitted: true, is_uploaded: false) }
end
