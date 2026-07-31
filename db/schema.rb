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

ActiveRecord::Schema[8.1].define(version: 2026_07_31_205500) do
  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "fact_question_flags", force: :cascade do |t|
    t.integer "category", null: false
    t.datetime "created_at", null: false
    t.text "details"
    t.integer "fact_question_id", null: false
    t.text "resolution_notes"
    t.datetime "reviewed_at"
    t.integer "reviewer_id"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["fact_question_id"], name: "index_fact_question_flags_on_fact_question_id"
    t.index ["reviewer_id"], name: "index_fact_question_flags_on_reviewer_id"
    t.index ["status"], name: "index_fact_question_flags_on_status"
    t.index ["user_id", "fact_question_id", "category"], name: "index_fact_flags_on_user_question_category", unique: true
    t.index ["user_id"], name: "index_fact_question_flags_on_user_id"
  end

  create_table "fact_question_proposals", force: :cascade do |t|
    t.integer "correct_option", null: false
    t.datetime "created_at", null: false
    t.integer "evidence_direction", null: false
    t.text "explanation", null: false
    t.text "importance_rationale", null: false
    t.integer "importance_weight", null: false
    t.integer "opinion_question_id", null: false
    t.json "options", null: false
    t.text "prompt", null: false
    t.integer "proposer_id", null: false
    t.integer "published_fact_question_id"
    t.text "review_notes"
    t.datetime "reviewed_at"
    t.integer "reviewer_id"
    t.string "source_name", null: false
    t.string "source_url", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["opinion_question_id"], name: "index_fact_question_proposals_on_opinion_question_id"
    t.index ["proposer_id"], name: "index_fact_question_proposals_on_proposer_id"
    t.index ["published_fact_question_id"], name: "index_fact_question_proposals_on_published_fact_question_id"
    t.index ["reviewer_id"], name: "index_fact_question_proposals_on_reviewer_id"
    t.index ["status"], name: "index_fact_question_proposals_on_status"
    t.check_constraint "correct_option BETWEEN 0 AND 3", name: "fact_question_proposals_correct_option_range"
    t.check_constraint "evidence_direction BETWEEN -1 AND 1", name: "fact_question_proposals_evidence_direction_range"
    t.check_constraint "importance_weight BETWEEN 1 AND 3", name: "fact_question_proposals_importance_weight_range"
  end

  create_table "fact_questions", force: :cascade do |t|
    t.integer "correct_option", null: false
    t.datetime "created_at", null: false
    t.integer "display_order", default: 0, null: false
    t.integer "evidence_direction", default: 0, null: false
    t.text "explanation", null: false
    t.text "importance_rationale", default: "This question currently has the standard importance weight; unequal weights will only be assigned after review.", null: false
    t.integer "importance_weight", default: 1, null: false
    t.integer "opinion_question_id", null: false
    t.json "options", null: false
    t.text "prompt", null: false
    t.string "source_name", null: false
    t.string "source_url", null: false
    t.datetime "updated_at", null: false
    t.index ["opinion_question_id", "display_order"], name: "index_fact_questions_on_opinion_and_order", unique: true
    t.index ["opinion_question_id"], name: "index_fact_questions_on_opinion_question_id"
    t.check_constraint "importance_weight BETWEEN 1 AND 3", name: "fact_questions_importance_weight_range"
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

  create_table "opinion_question_proposals", force: :cascade do |t|
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.text "final_statement"
    t.string "final_title"
    t.string "geographic_scope"
    t.integer "proposer_id", null: false
    t.integer "published_opinion_question_id"
    t.text "rationale", null: false
    t.text "review_notes"
    t.datetime "reviewed_at"
    t.integer "reviewer_id"
    t.text "statement", null: false
    t.integer "status", default: 0, null: false
    t.text "tags_text", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_opinion_question_proposals_on_category_id"
    t.index ["proposer_id"], name: "index_opinion_question_proposals_on_proposer_id"
    t.index ["published_opinion_question_id"], name: "idx_on_published_opinion_question_id_d5b4d5e97a"
    t.index ["reviewer_id"], name: "index_opinion_question_proposals_on_reviewer_id"
    t.index ["status"], name: "index_opinion_question_proposals_on_status"
  end

  create_table "opinion_question_reactions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "kind", null: false
    t.integer "opinion_question_id", null: false
    t.text "reason"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["opinion_question_id"], name: "index_opinion_question_reactions_on_opinion_question_id"
    t.index ["user_id", "opinion_question_id"], name: "index_opinion_reactions_on_user_and_question", unique: true
    t.index ["user_id"], name: "index_opinion_question_reactions_on_user_id"
  end

  create_table "opinion_question_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "opinion_question_id", null: false
    t.integer "tag_id", null: false
    t.datetime "updated_at", null: false
    t.index ["opinion_question_id", "tag_id"], name: "index_opinion_question_tags_uniquely", unique: true
    t.index ["opinion_question_id"], name: "index_opinion_question_tags_on_opinion_question_id"
    t.index ["tag_id"], name: "index_opinion_question_tags_on_tag_id"
  end

  create_table "opinion_questions", force: :cascade do |t|
    t.string "accent", default: "teal", null: false
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.integer "display_order", default: 0, null: false
    t.boolean "live", default: true, null: false
    t.json "response_options", null: false
    t.string "slug", null: false
    t.text "statement", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_opinion_questions_on_category_id"
    t.index ["display_order"], name: "index_opinion_questions_on_display_order", unique: true
    t.index ["live"], name: "index_opinion_questions_on_live"
    t.index ["slug"], name: "index_opinion_questions_on_slug", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
    t.index ["slug"], name: "index_tags_on_slug", unique: true
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
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "fact_question_flags", "fact_questions"
  add_foreign_key "fact_question_flags", "users"
  add_foreign_key "fact_question_flags", "users", column: "reviewer_id"
  add_foreign_key "fact_question_proposals", "fact_questions", column: "published_fact_question_id"
  add_foreign_key "fact_question_proposals", "opinion_questions"
  add_foreign_key "fact_question_proposals", "users", column: "proposer_id"
  add_foreign_key "fact_question_proposals", "users", column: "reviewer_id"
  add_foreign_key "fact_questions", "opinion_questions"
  add_foreign_key "fact_responses", "fact_questions"
  add_foreign_key "fact_responses", "users"
  add_foreign_key "opinion_question_proposals", "categories"
  add_foreign_key "opinion_question_proposals", "opinion_questions", column: "published_opinion_question_id"
  add_foreign_key "opinion_question_proposals", "users", column: "proposer_id"
  add_foreign_key "opinion_question_proposals", "users", column: "reviewer_id"
  add_foreign_key "opinion_question_reactions", "opinion_questions"
  add_foreign_key "opinion_question_reactions", "users"
  add_foreign_key "opinion_question_tags", "opinion_questions"
  add_foreign_key "opinion_question_tags", "tags"
  add_foreign_key "opinion_questions", "categories"
  add_foreign_key "user_opinions", "opinion_questions"
  add_foreign_key "user_opinions", "users"
end
