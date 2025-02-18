class AddIsDbUpdatedToVideos < ActiveRecord::Migration[7.1]
  def change
    add_column :videos, :is_db_updated, :boolean, default: false
  end
end
