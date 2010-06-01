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

ActiveRecord::Schema.define(:version => 20100427140143) do

  create_table "consumer_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "type",       :limit => 30
    t.string   "token",      :limit => 1024
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["email"], :name => "index_contacts_on_email"
  add_index "contacts", ["name"], :name => "index_contacts_on_name"

  create_table "educations", :force => true do |t|
    t.integer  "user_id"
    t.string   "linkedin_id"
    t.string   "school_name"
    t.string   "degree"
    t.string   "field_of_study"
    t.string   "activities",     :limit => 500
    t.integer  "start_year"
    t.integer  "start_month"
    t.integer  "end_year"
    t.integer  "end_month"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "external_users", :force => true do |t|
    t.integer  "user_id"
    t.string   "service"
    t.string   "service_id"
    t.string   "service_handle"
    t.boolean  "confirmed",      :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "external_users", ["service_handle"], :name => "index_external_users_on_service_handle"
  add_index "external_users", ["service_id"], :name => "index_external_users_on_service_id"
  add_index "external_users", ["user_id"], :name => "index_external_users_on_user_id"

  create_table "invitations", :force => true do |t|
    t.integer  "sender_id"
    t.string   "token",                           :null => false
    t.string   "recipient_email",                 :null => false
    t.string   "message",         :limit => 5000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["recipient_email"], :name => "index_invitations_on_recipient_email"
  add_index "invitations", ["sender_id"], :name => "index_invitations_on_sender_id"
  add_index "invitations", ["token"], :name => "index_invitations_on_token", :unique => true

  create_table "message_recipients", :force => true do |t|
    t.integer  "message_id",    :null => false
    t.integer  "receiver_id",   :null => false
    t.string   "receiver_type", :null => false
    t.string   "kind",          :null => false
    t.integer  "position"
    t.string   "state",         :null => false
    t.datetime "hidden_at"
  end

  add_index "message_recipients", ["message_id", "kind", "position"], :name => "index_message_recipients_on_message_id_and_kind_and_position", :unique => true

  create_table "messages", :force => true do |t|
    t.integer  "sender_id",   :null => false
    t.string   "sender_type", :null => false
    t.text     "subject"
    t.text     "body"
    t.string   "state",       :null => false
    t.datetime "hidden_at"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "positions", :force => true do |t|
    t.integer  "user_id"
    t.string   "linkedin_id"
    t.string   "title"
    t.string   "summary"
    t.integer  "start_year"
    t.integer  "start_month"
    t.integer  "end_year"
    t.integer  "end_month"
    t.string   "is_current"
    t.string   "company"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "linkedin_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "headline"
    t.string   "location"
    t.string   "country_code"
    t.string   "industry"
    t.string   "summary",            :limit => 2000
    t.string   "specialties",        :limit => 500
    t.string   "proposal_comments",  :limit => 500
    t.string   "associations",       :limit => 500
    t.string   "honors",             :limit => 500
    t.string   "picture_url",        :limit => 500
    t.string   "public_profile_url", :limit => 500
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", :force => true do |t|
    t.integer "row_number"
    t.integer "job_id"
    t.string  "title"
    t.integer "next_id"
    t.string  "next_title"
    t.integer "thecount"
    t.float   "thepct"
  end

  create_table "title_trigrams", :force => true do |t|
    t.integer "title_id"
    t.string  "token",    :null => false
  end

  create_table "titles", :id => false, :force => true do |t|
    t.integer "id"
    t.string  "title"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "linkedin_token"
    t.string   "linkedin_secret"
    t.integer  "invitation_limit",  :default => 20000
  end

end
