class Video < ApplicationRecord
  scope :not_downloaded, -> { where(is_downloaded: false) }
  scope :downloaded_but_not_uploaded, -> { where(is_downloaded: true, is_uploaded: false) }
end
