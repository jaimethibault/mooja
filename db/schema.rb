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

ActiveRecord::Schema.define(version: 20170831104913) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "attachinary_files", force: :cascade do |t|
    t.string   "attachinariable_type"
    t.integer  "attachinariable_id"
    t.string   "scope"
    t.string   "public_id"
    t.string   "version"
    t.integer  "width"
    t.integer  "height"
    t.string   "format"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attachinariable_type", "attachinariable_id", "scope"], name: "by_scoped_parent", using: :btree
  end

  create_table "bookings", force: :cascade do |t|
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "status"
    t.integer  "user_id"
    t.integer  "surfcamp_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "total_discounted_price"
    t.integer  "total_original_price"
    t.integer  "pax_nb"
    t.index ["surfcamp_id"], name: "index_bookings_on_surfcamp_id", using: :btree
    t.index ["user_id"], name: "index_bookings_on_user_id", using: :btree
  end

  create_table "discounts", force: :cascade do |t|
    t.integer  "discounted_price"
    t.datetime "limit_offer_date"
    t.datetime "discount_starts_at"
    t.datetime "discount_ends_at"
    t.integer  "surfcamp_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["surfcamp_id"], name: "index_discounts_on_surfcamp_id", using: :btree
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "type"
    t.integer  "price_per_night"
    t.integer  "capacity"
    t.integer  "surfcamp_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["surfcamp_id"], name: "index_rooms_on_surfcamp_id", using: :btree
  end

  create_table "surfcamps", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "rating"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "price_per_night_per_person"
    t.integer  "capacity"
    t.float    "waves_period"
    t.float    "water_temp"
    t.float    "air_temp"
    t.string   "weather_desc"
    t.integer  "price_cents",                default: 0, null: false
    t.string   "city"
    t.string   "airport_code"
    t.string   "country"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "facebook_picture_url"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "token"
    t.datetime "token_expiry"
    t.boolean  "admin",                  default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "bookings", "surfcamps"
  add_foreign_key "bookings", "users"
  add_foreign_key "discounts", "surfcamps"
  add_foreign_key "rooms", "surfcamps"
end
