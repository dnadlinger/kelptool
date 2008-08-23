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

ActiveRecord::Schema.define(:version => 20080821131641) do

  create_table "bills", :force => true do |t|
    t.integer  "serial_number"
    t.string   "type_key"
    t.integer  "rental_action_id"
    t.string   "filename"
    t.string   "content_type"
    t.integer  "size"
    t.integer  "db_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "adress"
    t.string   "place"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
    t.string   "postcode"
  end

  create_table "customers", :force => true do |t|
    t.text     "comment"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price_factor"
  end

  create_table "db_files", :force => true do |t|
    t.binary "data"
  end

  create_table "employees", :force => true do |t|
    t.text     "comment"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees_skills", :id => false, :force => true do |t|
    t.integer "employee_id"
    t.integer "skill_id"
  end

  create_table "item_categories", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "item_notes", :force => true do |t|
    t.text     "content"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_quantity_changes", :force => true do |t|
    t.integer  "amount"
    t.text     "reason"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_rentals", :force => true do |t|
    t.integer  "item_id"
    t.integer  "rental_action_id"
    t.integer  "quantity"
    t.boolean  "handed_out",       :default => false
    t.boolean  "returned",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "name",                            :null => false
    t.integer  "total_count"
    t.integer  "num_in_stock"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_category_id", :default => 0, :null => false
    t.integer  "price_id"
    t.string   "price_type"
  end

  create_table "phone_number_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phone_numbers", :force => true do |t|
    t.string   "number"
    t.integer  "type_id"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rental_actions", :force => true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
    t.boolean  "deactivated", :default => false
  end

  create_table "simple_prices", :force => true do |t|
    t.decimal  "daily_rate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

end
