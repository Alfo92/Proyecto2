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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170617212129) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agent_listings", force: :cascade do |t|
    t.integer  "agent_id"
    t.integer  "listing_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "agent_listings", ["listing_id"], name: "agent_listings_listing_id_idx", using: :btree

  create_table "agent_profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "license",        limit: 510
    t.string   "specialties",    limit: 510, default: "--- {}\\n"
    t.integer  "lifetime_views"
    t.string   "slug",           limit: 510
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "agent_profiles", ["user_id"], name: "agent_profiles_user_id_idx", using: :btree

  create_table "average_caches", force: :cascade do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type", limit: 510
    t.float    "avg",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "average_caches", ["rater_id"], name: "average_caches_rater_id_idx", using: :btree

  create_table "listing_photos", force: :cascade do |t|
    t.string   "file_file_name",    limit: 510
    t.string   "file_content_type", limit: 510
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "file_fingerprint",  limit: 510
    t.string   "name",              limit: 510
    t.string   "comment",           limit: 510
    t.integer  "sort_order"
    t.integer  "listing_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.datetime "deleted_at"
  end

  add_index "listing_photos", ["listing_id"], name: "listing_photos_listing_id_idx", using: :btree

  create_table "listing_properties", force: :cascade do |t|
    t.integer  "listing_id"
    t.string   "key",        limit: 510
    t.string   "value",      limit: 510
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "listing_properties", ["listing_id"], name: "listing_properties_listing_id_idx", using: :btree

  create_table "listing_types", force: :cascade do |t|
    t.string   "name",       limit: 510
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "SortValue",              default: 1
  end

  create_table "listings", force: :cascade do |t|
    t.string   "type",             limit: 510
    t.integer  "listing_type"
    t.boolean  "featured"
    t.text     "description"
    t.string   "property_url",     limit: 510
    t.integer  "step",                                        default: 0
    t.integer  "location_id"
    t.integer  "agent_id"
    t.integer  "status_id",                                   default: 0,         null: false
    t.decimal  "list_price",                   precision: 10
    t.date     "list_date"
    t.integer  "primary_photo_id"
    t.boolean  "hide_address"
    t.boolean  "sold"
    t.string   "address1",         limit: 510
    t.string   "address2",         limit: 510
    t.string   "city",             limit: 510
    t.string   "state",            limit: 510
    t.string   "postal_code",      limit: 510
    t.string   "country",          limit: 510
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.integer  "views_count",                                 default: 0
    t.string   "price_type",       limit: 510,                default: "dolares"
    t.text     "full_info"
    t.boolean  "accept_terms",                                default: false
    t.datetime "deleted_at"
  end

  add_index "listings", ["full_info"], name: "index_listings_on_full_info", using: :btree
  add_index "listings", ["primary_photo_id"], name: "listings_primary_photo_id_idx", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "from_id"
    t.string   "from_name",  limit: 510
    t.string   "from_email", limit: 510
    t.string   "from_phone", limit: 510
    t.string   "message",    limit: 510
    t.integer  "to_id"
    t.string   "to_email",   limit: 510
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "listing_id"
  end

  add_index "messages", ["from_id"], name: "messages_from_id_idx", using: :btree
  add_index "messages", ["listing_id"], name: "messages_listing_id_idx", using: :btree
  add_index "messages", ["to_id"], name: "messages_to_id_idx", using: :btree

  create_table "overall_averages", force: :cascade do |t|
    t.integer  "rateable_id"
    t.string   "rateable_type", limit: 510
    t.float    "overall_avg",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: :cascade do |t|
    t.text     "title"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rates", force: :cascade do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type", limit: 510
    t.float    "stars",                     null: false
    t.string   "dimension",     limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["rater_id"], name: "rates_rater_id_idx", using: :btree

  create_table "rating_caches", force: :cascade do |t|
    t.integer  "cacheable_id"
    t.string   "cacheable_type", limit: 510
    t.float    "avg",                        null: false
    t.integer  "qty",                        null: false
    t.string   "dimension",      limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "saved_listings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "listing_id"
    t.integer  "sort_order"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  add_index "saved_listings", ["listing_id"], name: "saved_listings_listing_id_idx", using: :btree
  add_index "saved_listings", ["user_id"], name: "saved_listings_user_id_idx", using: :btree

  create_table "search_histories", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "searchs_for"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "search_histories", ["user_id"], name: "search_histories_user_id_idx", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 510, null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "sessions_session_id_key", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 510, default: "", null: false
    t.string   "encrypted_password",     limit: 510, default: "", null: false
    t.string   "reset_password_token",   limit: 510
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 510
    t.string   "last_sign_in_ip",        limit: 510
    t.string   "confirmation_token",     limit: 510
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 510
    t.string   "name",                   limit: 510, default: "", null: false
    t.string   "phone_number",           limit: 510
    t.string   "company",                limit: 510
    t.text     "about"
    t.string   "type",                   limit: 510
    t.string   "kind",                   limit: 510
    t.string   "avatar_file_name",       limit: 510
    t.string   "avatar_content_type",    limit: 510
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "total_profile_views"
    t.datetime "subscribed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "views_count",                        default: 0
    t.string   "provider",               limit: 510
    t.string   "uid",                    limit: 510
    t.string   "customer_id",            limit: 510
    t.string   "language"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.boolean  "is_admin"
    t.datetime "deleted_at"
    t.datetime "disabled_at"
  end

  add_index "users", ["confirmation_token"], name: "users_confirmation_token_key", unique: true, using: :btree
  add_index "users", ["email"], name: "users_email_key", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "users_reset_password_token_key", unique: true, using: :btree

  create_table "views", force: :cascade do |t|
    t.string   "viewable_type", limit: 510
    t.integer  "viewable_id"
    t.string   "ip_address",    limit: 510
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_foreign_key "agent_listings", "listings"
  add_foreign_key "agent_profiles", "users"
  add_foreign_key "average_caches", "users", column: "rater_id"
  add_foreign_key "listing_photos", "listings"
  add_foreign_key "listing_properties", "listings"
  add_foreign_key "listings", "listing_photos", column: "primary_photo_id"
  add_foreign_key "messages", "listings"
  add_foreign_key "messages", "users", column: "from_id"
  add_foreign_key "messages", "users", column: "to_id"
  add_foreign_key "rates", "users", column: "rater_id"
  add_foreign_key "saved_listings", "listings"
  add_foreign_key "saved_listings", "users"
  add_foreign_key "search_histories", "users"
end
