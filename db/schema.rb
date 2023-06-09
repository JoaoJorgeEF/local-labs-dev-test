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

ActiveRecord::Schema[7.0].define(version: 2023_05_23_231946) do
  create_table "comments", charset: "utf8mb4", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id", null: false
    t.bigint "story_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_comments_on_story_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "organizations", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
  end

  create_table "stories", charset: "utf8mb4", force: :cascade do |t|
    t.string "headline"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "writer_id"
    t.bigint "reviewer_id"
    t.string "story_status"
    t.boolean "comments_open", default: true
    t.bigint "organization_id", null: false
    t.index ["organization_id"], name: "index_stories_on_organization_id"
    t.index ["reviewer_id"], name: "index_stories_on_reviewer_id"
    t.index ["writer_id"], name: "index_stories_on_writer_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "organization_slug"
    t.string "user_type"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_slug"], name: "fk_rails_9cb376db16"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "comments", "stories"
  add_foreign_key "comments", "users"
  add_foreign_key "stories", "organizations"
  add_foreign_key "stories", "users", column: "reviewer_id"
  add_foreign_key "stories", "users", column: "writer_id"
  add_foreign_key "users", "organizations", column: "organization_slug", primary_key: "slug"
end
