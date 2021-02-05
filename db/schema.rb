# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_05_193657) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blog_posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.tsvector "search"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "lower((title)::text)", name: "index_blog_posts_on_lower_title", unique: true
    t.index ["search"], name: "index_blog_posts_on_search", using: :gin
  end

  create_table "brands", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "buyers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "email"], name: "index_buyers_on_name_and_email", unique: true
  end

  create_table "car_value_references", force: :cascade do |t|
    t.bigint "car_id", null: false
    t.date "competency", null: false
    t.decimal "value", precision: 14, scale: 2
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["car_id"], name: "index_car_value_references_on_car_id"
    t.index ["competency"], name: "index_car_value_references_on_competency"
  end

  create_table "cars", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "brand_id", null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "score"
    t.boolean "active", default: true, null: false
    t.string "serial_number"
    t.string "serial_number_index_btree"
    t.string "serial_number_index_hash"
    t.index ["brand_id"], name: "index_cars_on_brand_id"
    t.index "lower((name)::text) varchar_pattern_ops", name: "index_on_lowercase_name"
    t.index ["name", "brand_id"], name: "index_car_name_brand_id", unique: true
    t.index ["score"], name: "index_cars_on_score", order: :desc, where: "active"
    t.index ["serial_number_index_btree"], name: "index_cars_on_serial_number_index_btree"
    t.index ["serial_number_index_hash"], name: "index_cars_on_serial_number_index_hash", using: :hash
  end

  create_table "reviews", force: :cascade do |t|
    t.string "reviewable_type"
    t.bigint "reviewable_id"
    t.string "reviewer_type"
    t.bigint "reviewer_id"
    t.text "content"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable_type_and_reviewable_id"
    t.index ["reviewer_type", "reviewer_id"], name: "index_reviews_on_reviewer_type_and_reviewer_id"
  end

  create_table "sales", force: :cascade do |t|
    t.bigint "car_id", null: false
    t.bigint "seller_id", null: false
    t.bigint "buyer_id", null: false
    t.bigint "car_value_reference_id", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "closed_at"
    t.index ["buyer_id"], name: "index_sales_on_buyer_id"
    t.index ["car_id"], name: "index_sales_on_car_id"
    t.index ["car_value_reference_id"], name: "index_sales_on_car_value_reference_id"
    t.index ["seller_id"], name: "index_sales_on_seller_id"
  end

  create_table "sellers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "email"], name: "index_sellers_on_name_and_email", unique: true
  end

  add_foreign_key "car_value_references", "cars"
  add_foreign_key "cars", "brands"
  add_foreign_key "sales", "buyers"
  add_foreign_key "sales", "car_value_references"
  add_foreign_key "sales", "cars"
  add_foreign_key "sales", "sellers"

  create_view "brand_with_cars", materialized: true, sql_definition: <<-SQL
      SELECT bb.id,
      bb.name,
      bb.created_at,
      bb.updated_at,
      ( SELECT array_to_json(array_agg(cvr.*)) AS array_to_json
             FROM ( SELECT cars.id,
                      cars.name,
                      ( SELECT car_value_references.value
                             FROM car_value_references
                            WHERE (car_value_references.car_id = cars.id)
                            ORDER BY car_value_references.competency DESC, car_value_references.created_at DESC
                           LIMIT 1) AS value
                     FROM cars
                    WHERE (cars.brand_id = bb.id)) cvr) AS cars
     FROM brands bb
    GROUP BY bb.id
   HAVING (( SELECT count(*) AS count
             FROM cars
            WHERE (cars.brand_id = bb.id)) > 0);
  SQL
  create_view "revenues", materialized: true, sql_definition: <<-SQL
      WITH last_month_of_the_year AS (
           SELECT (concat(date_part('YEAR'::text, CURRENT_DATE), '-', '12', '-', '01'))::date AS last_month
          ), months AS (
           SELECT (months.months)::date AS month
             FROM generate_series(('2018-01-01'::date)::timestamp with time zone, (( SELECT last_month_of_the_year.last_month
                     FROM last_month_of_the_year))::timestamp with time zone, '1 mon'::interval) months(months)
          ), sells AS (
           SELECT mm.month,
              s.id,
              s.car_id,
              s.seller_id,
              s.buyer_id,
              s.car_value_reference_id,
              s.description,
              s.created_at,
              s.updated_at,
              s.closed_at,
              cvr.id,
              cvr.car_id,
              cvr.competency,
              cvr.value,
              cvr.created_at,
              cvr.updated_at
             FROM ((months mm
               LEFT JOIN sales s ON ((date_trunc('month'::text, s.closed_at) = mm.month)))
               LEFT JOIN car_value_references cvr ON ((s.car_value_reference_id = cvr.id)))
          )
   SELECT sum(COALESCE(ss.value, (0)::numeric)) AS value,
      ss.month AS competency
     FROM sells ss(month, id, car_id, seller_id, buyer_id, car_value_reference_id, description, created_at, updated_at, closed_at, id_1, car_id_1, competency, value, created_at_1, updated_at_1)
    GROUP BY ss.month
    ORDER BY ss.month;
  SQL
end
