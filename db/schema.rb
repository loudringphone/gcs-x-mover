# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_05_16_123328) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "videos", force: :cascade do |t|
    t.integer "presentation_id"
    t.string "cloud_url"
    t.integer "mission_id"
    t.string "agency_name"
    t.string "assignee_name"
    t.string "gospel"
    t.string "country"
    t.string "title"
    t.boolean "is_downloaded", default: false
    t.string "download_directory"
    t.boolean "is_uploaded", default: false
    t.string "youtube_id"
    t.string "youtube_thumbnail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["presentation_id"], name: "index_videos_on_presentation_id", unique: true
    t.index ["title"], name: "index_videos_on_title", unique: true
  end

end
