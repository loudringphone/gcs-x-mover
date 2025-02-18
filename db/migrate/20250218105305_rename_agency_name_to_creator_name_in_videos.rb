class RenameAgencyNameToCreatorNameInVideos < ActiveRecord::Migration[7.1]
  def change
    rename_column :videos, :agency_name, :creator_name
  end
end
