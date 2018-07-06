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

ActiveRecord::Schema.define(version: 2018_07_04_145103) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.bigint "deck_id"
    t.bigint "user_id"
    t.string "front", limit: 150, null: false
    t.string "back", limit: 150, null: false
    t.string "difficulty_level", limit: 6, default: "medium", null: false
    t.integer "views_count", default: 0, null: false
    t.boolean "learned", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deck_id"], name: "index_cards_on_deck_id"
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "decks", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name", limit: 75, null: false
    t.string "detail", limit: 255
    t.integer "cards_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_decks_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.bigint "user_id"
    t.string "locale", limit: 5, default: "pt-BR", null: false
    t.integer "cards_per_review", default: 30, null: false
    t.integer "repeat_easy_card", default: 1, null: false
    t.integer "repeat_medium_card", default: 2, null: false
    t.integer "repeat_hard_card", default: 3, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", limit: 40, null: false
    t.string "last_name", limit: 40, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "cards", "decks"
  add_foreign_key "cards", "users"
  add_foreign_key "decks", "users"
  add_foreign_key "settings", "users"
end
