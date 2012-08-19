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

ActiveRecord::Schema.define(:version => 20120529170128) do

  create_table "addresses", :force => true do |t|
    t.string   "street"
    t.string   "city"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.string   "country_code"
    t.string   "state_code"
  end

  create_table "admins", :force => true do |t|
    t.string   "email",                :default => "", :null => false
    t.string   "encrypted_password",   :default => "", :null => false
    t.integer  "sign_in_count",        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",      :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true

  create_table "company_types", :force => true do |t|
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "education_levels", :force => true do |t|
    t.string   "education"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "employment_classes", :force => true do |t|
    t.string   "classification"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "favourites", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "job_pref_positions", :id => false, :force => true do |t|
    t.integer "position_type_id"
    t.integer "job_preference_id"
  end

  create_table "job_preferences", :force => true do |t|
    t.integer  "education_level"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "user_id"
    t.string   "address"
    t.boolean  "visible",         :default => true
    t.boolean  "searchable",      :default => true
  end

  create_table "position_areas", :force => true do |t|
    t.string   "area"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "position_types", :force => true do |t|
    t.string   "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posters", :force => true do |t|
    t.boolean  "approved",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "posting_positions", :id => false, :force => true do |t|
    t.integer "post_id"
    t.integer "position_type_id"
  end

  create_table "posts", :force => true do |t|
    t.integer  "poster_id"
    t.date     "start"
    t.date     "expiry"
    t.integer  "status",            :default => 0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "title"
    t.text     "description"
    t.integer  "education_level"
    t.integer  "position_area"
    t.integer  "employment_class"
    t.string   "info_file_name"
    t.string   "info_content_type"
    t.integer  "info_file_size"
    t.datetime "info_updated_at"
    t.integer  "address_id"
  end

  add_index "posts", ["id"], :name => "index_posts_on_id"

  create_table "profiles", :force => true do |t|
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "name"
    t.string   "pref_email"
    t.string   "phone"
    t.integer  "user_id"
    t.binary   "resume"
    t.string   "resume_file_name"
    t.string   "resume_content_type"
    t.integer  "resume_file_size"
    t.datetime "resume_updated_at"
    t.boolean  "public",              :default => true
    t.text     "bio"
    t.text     "linkedin"
    t.string   "linkedin_url"
    t.string   "personal_url"
    t.string   "dblp_url"
  end

  create_table "redirections", :id => false, :force => true do |t|
    t.integer "from_post"
    t.integer "to_post"
  end

  add_index "redirections", ["from_post", "to_post"], :name => "index_redirections_on_from_post_and_to_post", :unique => true

  create_table "scrape_logs", :force => true do |t|
    t.date     "dbworld_date"
    t.string   "dbworld_link"
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "seekers", :force => true do |t|
    t.integer  "position_type_id"
    t.integer  "education_level_id"
    t.string   "pref_email"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "seekers", ["education_level_id"], :name => "index_seekers_on_education_level_id"
  add_index "seekers", ["position_type_id"], :name => "index_seekers_on_position_type_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "utype",                  :default => 2
    t.integer  "poster"
    t.integer  "seeker"
    t.boolean  "admin"
    t.boolean  "approved_poster",        :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
