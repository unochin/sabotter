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

ActiveRecord::Schema.define(version: 2020_01_25_024414) do

  create_table "authentications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "tasks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title", null: false
    t.text "tweet_content", null: false
    t.integer "repeat_flag", default: 0, null: false
    t.integer "pause_flag", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "tweet_datetime"
    t.time "repeat_tweet_time"
    t.integer "tweet_sun"
    t.integer "tweet_mon"
    t.integer "tweet_tue"
    t.integer "tweet_wed"
    t.integer "tweet_thu"
    t.integer "tweet_fri"
    t.integer "tweet_sat"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "icon_img_url"
    t.string "enc_access_token"
    t.string "enc_access_token_secret"
    t.string "salt"
    t.string "secret_salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enc_access_token", "enc_access_token_secret"], name: "index_users_on_enc_access_token_and_enc_access_token_secret", unique: true
  end

  add_foreign_key "tasks", "users"
end
