# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160501204638) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genres", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "login_attempts", force: :cascade do |t|
    t.string   "login_key"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "materials", force: :cascade do |t|
    t.integer  "song_id"
    t.string   "title"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.string   "kind"
  end

  add_index "materials", ["song_id"], name: "index_materials_on_song_id", using: :btree

  create_table "playlists", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "spotify_id"
  end

  create_table "playlists_songs", force: :cascade do |t|
    t.integer  "playlist_id"
    t.integer  "song_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "playlists_songs", ["playlist_id"], name: "index_playlists_songs_on_playlist_id", using: :btree
  add_index "playlists_songs", ["song_id"], name: "index_playlists_songs_on_song_id", using: :btree

  create_table "playlists_users", force: :cascade do |t|
    t.integer  "playlist_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "playlists_users", ["playlist_id"], name: "index_playlists_users_on_playlist_id", using: :btree
  add_index "playlists_users", ["user_id"], name: "index_playlists_users_on_user_id", using: :btree

  create_table "songs", force: :cascade do |t|
    t.string   "name"
    t.string   "songsterr_url"
    t.integer  "genre_id"
    t.integer  "difficulty"
    t.integer  "artist_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.text     "chord_text"
    t.string   "spotify_track_id"
    t.string   "spotify_url"
    t.string   "album_artwork_url"
  end

  add_index "songs", ["artist_id"], name: "index_songs_on_artist_id", using: :btree
  add_index "songs", ["genre_id"], name: "index_songs_on_genre_id", using: :btree

  create_table "user_song_views", force: :cascade do |t|
    t.integer  "song_id"
    t.integer  "user_id"
    t.integer  "view_cnt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_song_views", ["song_id"], name: "index_user_song_views_on_song_id", using: :btree
  add_index "user_song_views", ["user_id"], name: "index_user_song_views_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "device_link_key"
    t.text     "spotify_info_hash"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "image"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "materials", "songs"
  add_foreign_key "songs", "artists"
  add_foreign_key "songs", "genres"
  add_foreign_key "user_song_views", "songs"
  add_foreign_key "user_song_views", "users"
end
