# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_29_130438) do

  create_table "matches", force: :cascade do |t|
    t.integer "user_id"
    t.integer "user_rank"
    t.integer "user_rank_new"
    t.integer "challenger_id"
    t.integer "challenger_rank"
    t.integer "challenger_rank_new"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "match_status"
  end

  create_table "members", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.date "dob"
    t.integer "num_games", default: 0
    t.integer "current_rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_members_on_email", unique: true
  end

end
