# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090118154031) do

  create_table "attached_files", :force => true do |t|
    t.integer  "study_id"
    t.integer  "download_count",        :default => 0
    t.integer  "document_file_size"
    t.string   "document_content_type"
    t.string   "document_file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
  end

  create_table "events", :force => true do |t|
    t.text     "data"
    t.string   "news_item_type"
    t.integer  "news_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "user_id"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.boolean  "read",       :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partnerships", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "requestee_id"
    t.integer  "requester_id"
    t.string   "message"
    t.boolean  "granted",      :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read",         :default => false, :null => false
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "studies", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "partnership_id"
    t.integer  "region_id"
    t.string   "category"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "login",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "remember_token",                         :null => false
    t.integer  "login_count"
    t.string   "password_salt",                          :null => false
    t.datetime "current_login_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.string   "avatar_file_size"
    t.boolean  "email_hidden",        :default => false
    t.string   "token"
  end

  create_table "watchings", :force => true do |t|
    t.integer  "study_id"
    t.integer  "user_id"
    t.text     "notes"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
