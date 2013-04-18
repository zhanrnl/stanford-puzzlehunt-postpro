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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130417230443) do

  create_table "callins", :force => true do |t|
    t.integer  "puzzle_id"
    t.integer  "team_id"
    t.string   "answer"
    t.string   "phone_num"
    t.datetime "time_called"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "answered"
  end

  create_table "puzzle_links", :force => true do |t|
    t.integer "puzzle1_id"
    t.integer "puzzle2_id"
  end

  create_table "puzzles", :force => true do |t|
    t.string   "internal_name"
    t.string   "puzzle_name"
    t.text     "body"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "starts_unlocked"
    t.string   "answer"
    t.boolean  "is_meta",          :default => false
    t.integer  "neighbors_needed", :default => 1
    t.integer  "xcoord"
    t.integer  "ycoord"
    t.string   "color"
  end

  create_table "questions", :force => true do |t|
    t.integer  "team_id"
    t.text     "question"
    t.string   "phone_num"
    t.datetime "time_called"
    t.boolean  "answered"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "notes"
  end

  create_table "resources", :force => true do |t|
    t.string   "original"
    t.string   "hashed"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "notes"
  end

  create_table "solves", :force => true do |t|
    t.datetime "time_solved"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "team_id"
    t.integer  "puzzle_id"
  end

  create_table "teams", :force => true do |t|
    t.string   "internal_name"
    t.string   "pass_hash"
    t.string   "team_name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
