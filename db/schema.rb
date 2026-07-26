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

ActiveRecord::Schema[8.1].define(version: 2026_07_26_130400) do
  create_table "fact_questions", force: :cascade do |t|
    t.integer "correct_option", null: false
    t.datetime "created_at", null: false
    t.integer "display_order", default: 0, null: false
    t.integer "evidence_direction", default: 0, null: false
    t.text "explanation", null: false
    t.integer "opinion_question_id", null: false
    t.json "options", null: false
    t.text "prompt", null: false
    t.string "source_name", null: false
    t.string "source_url", null: false
    t.datetime "updated_at", null: false
    t.index ["opinion_question_id", "display_order"], name: "index_fact_questions_on_opinion_and_order", unique: true
    t.index ["opinion_question_id"], name: "index_fact_questions_on_opinion_question_id"
  end

  create_table "fact_responses", force: :cascade do |t|
    t.datetime "answered_at", null: false
    t.boolean "correct", null: false
    t.datetime "created_at", null: false
    t.integer "fact_question_id", null: false
    t.integer "selected_option", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.decimal "weight_after", precision: 5, scale: 2, null: false
    t.decimal "weight_before", precision: 5, scale: 2, null: false
    t.index ["fact_question_id"], name: "index_fact_responses_on_fact_question_id"
    t.index ["user_id", "fact_question_id"], name: "index_fact_responses_on_user_id_and_fact_question_id", unique: true
    t.index ["user_id"], name: "index_fact_responses_on_user_id"
  end

  create_table "opinion_questions", force: :cascade do |t|
    t.string "accent", default: "teal", null: false
    t.datetime "created_at", null: false
    t.integer "display_order", default: 0, null: false
    t.json "response_options", null: false
    t.string "slug", null: false
    t.text "statement", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["display_order"], name: "index_opinion_questions_on_display_order", unique: true
    t.index ["slug"], name: "index_opinion_questions_on_slug", unique: true
  end

  create_table "user_opinions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "opinion_question_id", null: false
    t.integer "position", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["opinion_question_id"], name: "index_user_opinions_on_opinion_question_id"
    t.index ["user_id", "opinion_question_id"], name: "index_user_opinions_on_user_id_and_opinion_question_id", unique: true
    t.index ["user_id"], name: "index_user_opinions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "fact_questions", "opinion_questions"
  add_foreign_key "fact_responses", "fact_questions"
  add_foreign_key "fact_responses", "users"
  add_foreign_key "user_opinions", "opinion_questions"
  add_foreign_key "user_opinions", "users"
end
