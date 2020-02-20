# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_20_195155) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cameras", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contact_number"
    t.datetime "last_checked_in", default: "2020-02-17 21:06:09"
    t.string "mac_address"
  end

  create_table "pictures", force: :cascade do |t|
    t.bigint "camera_id"
    t.string "phone_number"
    t.string "photo_url"
    t.datetime "created_at", default: "2020-02-09 18:24:30", null: false
    t.datetime "updated_at", default: "2020-02-09 18:24:30", null: false
    t.boolean "sent_to_user", default: false
    t.index ["camera_id"], name: "index_pictures_on_camera_id"
  end

  create_table "unknown_mac_addresses", force: :cascade do |t|
    t.string "mac_address"
    t.datetime "last_called"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "pictures", "cameras"
end
