class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos do |t|
      t.string :presentation_id
      t.string :cloud_url
      t.boolean :is_downloaded
      t.string :download_directory
      t.boolean :is_uploaded

      t.timestamps
    end
  end
end
