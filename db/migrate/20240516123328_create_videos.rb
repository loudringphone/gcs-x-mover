class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos do |t|
      t.integer :presentation_id
      t.string :cloud_url
      t.integer :mission_id
      t.string :agency_name
      t.string :assignee_name
      t.string :gospel
      t.string :country

      t.string :title
      t.boolean :is_downloaded, default: false
      t.string :download_directory
      t.boolean :is_uploaded, default: false
      t.string :youtube_id
      t.timestamps
    end

    add_index :videos, :presentation_id, unique: true
    add_index :videos, :title, unique: true
  end
end