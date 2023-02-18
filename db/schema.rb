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

ActiveRecord::Schema[7.0].define(version: 2022_12_26_161958) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allowed_origins", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.string "origin", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id", "origin"], name: "index_allowed_origins_on_game_id_and_origin", unique: true
    t.index ["game_id"], name: "index_allowed_origins_on_game_id"
  end

  create_table "game_signals", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "sender_id", null: false
    t.text "data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_signals_on_game_id"
    t.index ["sender_id"], name: "index_game_signals_on_sender_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name", limit: 32, null: false
    t.string "version", limit: 32, default: "0.0.0"
    t.integer "status", default: 0
    t.text "pem", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_games_on_name", unique: true
  end

  create_table "player_signals", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "sender_id", null: false
    t.text "data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_player_signals_on_player_id"
    t.index ["sender_id"], name: "index_player_signals_on_sender_id"
  end

  create_table "players", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.string "name", limit: 32, null: false
    t.integer "status", default: 0
    t.datetime "last_play_at", default: -> { "now()" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_players_on_game_id"
    t.index ["last_play_at"], name: "index_players_on_last_play_at"
    t.index ["status"], name: "index_players_on_status"
  end

  create_table "scoreboard_items", force: :cascade do |t|
    t.bigint "scoreboard_id", null: false
    t.bigint "player_id", null: false
    t.bigint "score", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_scoreboard_items_on_player_id"
    t.index ["scoreboard_id", "player_id"], name: "index_scoreboard_items_on_scoreboard_id_and_player_id", unique: true
    t.index ["scoreboard_id"], name: "index_scoreboard_items_on_scoreboard_id"
  end

  create_table "scoreboards", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.string "name", limit: 64, null: false
    t.integer "rank_order", limit: 2, null: false
    t.integer "index", limit: 2, null: false
    t.boolean "is_overwrite_best_score", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id", "index"], name: "index_scoreboards_on_game_id_and_index", unique: true
    t.index ["game_id"], name: "index_scoreboards_on_game_id"
  end

  create_table "shared_saves", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.text "data", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_shared_saves_on_player_id", unique: true
  end

  add_foreign_key "allowed_origins", "games"
  add_foreign_key "game_signals", "games"
  add_foreign_key "game_signals", "players", column: "sender_id"
  add_foreign_key "player_signals", "players"
  add_foreign_key "player_signals", "players", column: "sender_id"
  add_foreign_key "players", "games"
  add_foreign_key "scoreboard_items", "players"
  add_foreign_key "scoreboard_items", "scoreboards"
  add_foreign_key "scoreboards", "games"
  add_foreign_key "shared_saves", "players"
end
