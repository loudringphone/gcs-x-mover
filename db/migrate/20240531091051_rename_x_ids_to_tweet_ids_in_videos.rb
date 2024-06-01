class RenameXIdsToTweetIdsInVideos < ActiveRecord::Migration[7.1]
  def change
    rename_column :videos, :x_ids, :tweet_ids
    add_column :videos, :thumbnail, :string
    add_column :videos, :is_splitted, :boolean, default: false
    add_column :videos, :splitted_files, :string, array: true, default: []

    add_index :videos, :splitted_files, using: :gin
  end
end
