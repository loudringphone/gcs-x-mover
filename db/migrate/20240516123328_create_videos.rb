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
      t.string :x_ids, array: true, default: []
      t.boolean :is_uploaded, default: false
      t.timestamps
    end

    add_index :videos, :presentation_id, unique: true
    add_index :videos, :title, unique: true
    add_index :videos, :x_ids, using: 'gin'
  end
end