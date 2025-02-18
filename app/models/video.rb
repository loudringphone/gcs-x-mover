class Video < ApplicationRecord
  has_one_attached :thumbnail

  scope :not_downloaded, -> { where(is_downloaded: false) }
  scope :downloaded_not_splitted, -> { where(is_downloaded: true, is_splitted: false) }
  scope :splitted_not_uploaded, -> { where(is_splitted: true, is_uploaded: false) }
  scope :uploaded_not_db_updated, -> { where(is_uploaded: true, is_db_updated: false) }
  scope :db_updated, -> { where(is_db_updated: true) }
end
