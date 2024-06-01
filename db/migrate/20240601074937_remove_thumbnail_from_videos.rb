class RemoveThumbnailFromVideos < ActiveRecord::Migration[7.1]
  def change
    remove_column :videos, :thumbnail, :string
  end
end
