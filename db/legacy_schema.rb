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

ActiveRecord::Schema[7.0].define(version: 0) do
  create_table "auto_entry_status", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "horse_id", null: false
    t.date "race_date"
    t.integer "race_num", limit: 1, default: 0, null: false
    t.string "status", collation: "utf8_bin"
    t.integer "user_id", null: false
    t.index ["horse_id", "race_date"], name: "horse_id", unique: true
    t.index ["status"], name: "status"
    t.index ["user_id"], name: "user_id"
  end

  create_table "auto_shipping_status", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "horse_id", null: false
    t.integer "location", null: false
    t.date "ship_date"
    t.string "status", collation: "utf8_bin"
    t.integer "user_id", null: false
    t.index ["horse_id", "ship_date"], name: "horse_id", unique: true
    t.index ["status"], name: "status"
    t.index ["user_id"], name: "user_id"
  end

  create_table "ff_activity", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Amount", limit: 1
    t.integer "Balance", limit: 2
    t.integer "Budget", limit: 3, default: 0, null: false
    t.date "Date"
    t.integer "Stable", limit: 2
    t.integer "Type", limit: 1, default: 0, null: false
    t.index ["Stable"], name: "Stable"
  end

  create_table "ff_activity_pts", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "1stYearPts", limit: 1, default: 0, null: false
    t.integer "2ndYearPts", limit: 1, default: 0, null: false
    t.string "Keyword", limit: 50, null: false
    t.integer "OtherPts", limit: 1, default: 0, null: false
  end

  create_table "ff_admin", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "BroodmareLimit", limit: 2, default: 25, null: false
    t.string "BugPassword", limit: 50, null: false, collation: "utf8_general_ci"
    t.date "EFUpdate", null: false
    t.integer "HorseLimit", limit: 2, default: 150, null: false
    t.integer "Members", limit: 2, default: 75, null: false
    t.integer "NoteLimit", limit: 1, null: false
    t.integer "RacerLimit", limit: 2, default: 25, null: false
    t.date "SatDeadline"
    t.integer "StartingBudget", limit: 3, default: 0, null: false
    t.integer "StartingHorses", limit: 1, default: 1, null: false
    t.integer "StudLimit", limit: 2, default: 5, null: false
    t.integer "WeanlingLimit", limit: 1, default: 0, null: false
    t.date "WedDeadline"
    t.integer "YearlingLimit", limit: 1, default: 0, null: false
  end

  create_table "ff_alerts", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.text "Alert", size: :long, null: false
    t.date "Date", null: false
    t.date "Expire"
    t.boolean "Newbies", default: true, null: false
    t.boolean "NonNewbies", default: true, null: false
    t.index ["Date"], name: "Date"
    t.index ["Expire"], name: "Expire"
  end

  create_table "ff_auctionbids", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Auction", limit: 2, default: 0, null: false
    t.integer "Bidder", limit: 2, default: 0, null: false
    t.integer "CurrentBid", default: 0, null: false
    t.string "Email", limit: 1, default: "N", null: false, collation: "latin1_swedish_ci"
    t.integer "Horse", limit: 3, default: 0, null: false
    t.integer "MaxBid"
    t.string "Message", null: false, collation: "latin1_swedish_ci"
    t.string "Time", limit: 10, collation: "latin1_swedish_ci"
  end

  create_table "ff_auctionhorses", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Auction", limit: 2, default: 0, null: false
    t.string "Comment", collation: "latin1_swedish_ci"
    t.integer "Horse", limit: 3, default: 0, null: false
    t.integer "Max"
    t.integer "Reserve"
    t.boolean "Sold", default: false, null: false
    t.index ["Auction", "Horse"], name: "Auction", unique: true
    t.index ["Horse"], name: "Horse"
    t.index ["Sold"], name: "Sold"
  end

  create_table "ff_auctions", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.boolean "AllowOutside", default: false, null: false
    t.boolean "AllowRes", default: true, null: false
    t.string "AllowStatus", default: "All", null: false, collation: "latin1_swedish_ci"
    t.integer "Auctioneer", limit: 2, default: 0, null: false
    t.integer "ConsignLimit", limit: 1
    t.datetime "End", precision: nil, null: false
    t.integer "PerPerson", limit: 1
    t.string "SellTime", default: "12", null: false
    t.integer "SpendingCap"
    t.datetime "Start", precision: nil, null: false
    t.string "Title", collation: "latin1_swedish_ci"
    t.index ["End"], name: "End"
    t.index ["Start"], name: "Start"
  end

  create_table "ff_bcstuds", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Stud"
    t.integer "Year", limit: 2, default: 0, null: false
    t.index ["Stud"], name: "Stud"
  end

  create_table "ff_boarding", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "days", limit: 1, null: false
    t.date "end_date"
    t.integer "farm_id", null: false
    t.integer "horse_id", null: false
    t.date "start_date", null: false
    t.index ["end_date"], name: "end_date"
    t.index ["farm_id"], name: "farm_id"
    t.index ["horse_id", "end_date"], name: "horse_end_date"
    t.index ["horse_id", "farm_id", "start_date"], name: "unique_boarding", unique: true
    t.index ["horse_id"], name: "horse_id"
    t.index ["start_date"], name: "start_date"
  end

  create_table "ff_breed_rankings", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "MinPts", limit: 1, null: false
    t.string "Ranking", limit: 25, null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_breedings", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "CustomFee", limit: 3, default: 0
    t.date "Date"
    t.date "Due"
    t.integer "Mare", default: 0, null: false
    t.string "MareComments", collation: "latin1_swedish_ci"
    t.integer "Owner", limit: 2, default: 0, null: false
    t.string "Status", limit: 1, default: "P", null: false, collation: "latin1_swedish_ci"
    t.integer "Stud"
    t.string "StudComments", collation: "latin1_swedish_ci"
    t.index ["Mare"], name: "Mare"
    t.index ["Stud"], name: "Stud"
  end

  create_table "ff_budgets", primary_key: "ID", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "Amount"
    t.integer "Balance"
    t.date "Date"
    t.string "Description"
    t.integer "Stable", limit: 2
    t.index ["Date"], name: "Date"
    t.index ["Description"], name: "description"
    t.index ["Stable", "Date", "Description"], name: "stable_date_description"
    t.index ["Stable", "Description"], name: "stable_description"
    t.index ["Stable"], name: "Stable"
  end

  create_table "ff_claims", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Claimer"
    t.date "Date"
    t.integer "Horse"
    t.integer "Owner"
    t.integer "Price", limit: 3
    t.date "RaceDay"
    t.integer "RaceNum", limit: 2
    t.index ["Claimer"], name: "Claimer"
    t.index ["Horse"], name: "horse"
    t.index ["RaceDay", "Claimer"], name: "RaceDay", unique: true
  end

  create_table "ff_colorwar", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Activity", collation: "latin1_swedish_ci"
    t.integer "Points", limit: 2, default: 0, null: false
    t.integer "PtsAvail", limit: 2, default: 0, null: false
    t.integer "Team", limit: 2, default: 0, null: false
  end

  create_table "ff_comments", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Comment", limit: 100, null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_cw_activities", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Activity", null: false, collation: "latin1_swedish_ci"
    t.timestamp "End", null: false
    t.timestamp "Start", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
  end

  create_table "ff_cw_entries", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.timestamp "Date", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "Horse", null: false
    t.integer "Member", limit: 2, null: false
    t.integer "Race", null: false
    t.integer "Team", limit: 2, null: false
    t.index ["Horse", "Race"], name: "Horse", unique: true
  end

  create_table "ff_cw_guess_order", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.boolean "active", null: false
    t.integer "guesser_id", null: false
    t.date "last_date", null: false
  end

  create_table "ff_cw_guesses", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.boolean "correct", null: false
    t.integer "guessed_id", null: false
    t.integer "guesser_id", null: false
    t.integer "secret_id", null: false
  end

  create_table "ff_cw_prize_offers", id: :integer, charset: "utf32", collation: "utf32_unicode_ci", force: :cascade do |t|
    t.integer "horse_id", null: false
    t.integer "user_id", null: false
    t.string "year", limit: 4, null: false, collation: "latin1_swedish_ci"
    t.index ["user_id", "horse_id"], name: "user_horse"
  end

  create_table "ff_cw_prizes", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "type", limit: 1, null: false
    t.integer "user_id", null: false
    t.integer "value", null: false
    t.string "year", limit: 4, null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_cw_race_votes", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.timestamp "Date", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "Entry", limit: 2, null: false
    t.integer "Member", limit: 2, null: false
    t.integer "Team", limit: 2, null: false
    t.boolean "Vote", null: false
  end

  create_table "ff_cw_results", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "position", limit: 1, null: false
    t.integer "user_id", null: false
    t.string "year", limit: 4, null: false, collation: "latin1_swedish_ci"
    t.index ["year", "user_id"], name: "year", unique: true
  end

  create_table "ff_cw_scores", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Activity", limit: 2, null: false
    t.timestamp "Date", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "Description", collation: "latin1_swedish_ci"
    t.integer "Points", limit: 2, null: false
    t.integer "Team", limit: 2, null: false
  end

  create_table "ff_cw_secrets", primary_key: "member_id", id: :integer, default: nil, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.boolean "active", null: false
    t.boolean "guessed", null: false
    t.integer "guesser_id", null: false
    t.text "secret", size: :medium, null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_cw_settings", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "name", null: false, collation: "latin1_swedish_ci"
    t.string "value", null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_cw_signups", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "captain", limit: 1, null: false
    t.date "date", null: false
    t.integer "user_id", null: false
    t.integer "year", null: false
  end

  create_table "ff_cw_teams", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.boolean "Captain", default: false, null: false
    t.timestamp "End", null: false
    t.integer "Member", limit: 2, null: false
    t.timestamp "Start", default: "2012-02-19 19:00:00", null: false
    t.integer "Team", limit: 2, null: false
    t.index ["Member"], name: "Member"
  end

  create_table "ff_deleted_stables", id: :integer, default: nil, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "balance", null: false
    t.date "date", null: false
    t.text "horses", null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_distinct_errors", id: false, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.text "error_details", null: false
    t.string "error_file", null: false
    t.integer "error_line", limit: 3
  end

  create_table "ff_donations", primary_key: "txn_id", id: { type: :string, limit: 19, collation: "latin1_swedish_ci" }, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.float "amount", null: false
    t.date "date", null: false
    t.integer "user_id", null: false
  end

  create_table "ff_equipment", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Equipment", limit: 20, collation: "latin1_swedish_ci"
    t.index ["Equipment"], name: "equipment"
  end

  create_table "ff_faq", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.text "Answer", size: :long, null: false, collation: "latin1_swedish_ci"
    t.integer "Category", limit: 1, default: 0, null: false
    t.text "Question", null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_faq_answers", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.text "answer", size: :long, null: false, collation: "latin1_swedish_ci"
    t.integer "category", limit: 1, null: false
    t.integer "order", limit: 1, default: 0, null: false
    t.string "question", null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_faq_articles", primary_key: "FileID", id: { type: :integer, unsigned: true }, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Approved", limit: 1, default: "N", collation: "latin1_swedish_ci"
    t.text "Articledata", size: :long, collation: "latin1_swedish_ci"
    t.integer "AuthorID", limit: 1, default: 0, null: false, unsigned: true
    t.integer "CatID", limit: 1, default: 0, null: false, unsigned: true
    t.string "Category", limit: 50, collation: "latin1_swedish_ci"
    t.string "Keywords", limit: 80, collation: "latin1_swedish_ci"
    t.integer "ParentID", limit: 1, default: 0, null: false, unsigned: true
    t.string "RatedTotal", limit: 5, default: "0", null: false, collation: "latin1_swedish_ci"
    t.string "RatingTotal", limit: 5, default: "0", null: false, collation: "latin1_swedish_ci"
    t.timestamp "SubmitDate", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
    t.string "Title", limit: 50, null: false, collation: "latin1_swedish_ci"
    t.integer "Views", limit: 3, default: 0
    t.index ["Keywords"], name: "Keywords"
  end

  create_table "ff_faq_categories", id: { type: :integer, unsigned: true }, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "approved", limit: 1, default: "Y", collation: "latin1_swedish_ci"
    t.string "category", limit: 50, null: false, collation: "latin1_swedish_ci"
    t.integer "parent", limit: 1, default: 0, null: false
    t.index ["parent", "approved"], name: "parent_search"
  end

  create_table "ff_faq_questions", primary_key: "QuestionID", id: { type: :integer, limit: 3 }, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Email", limit: 50, null: false, collation: "latin1_swedish_ci"
    t.string "Name", limit: 50, null: false, collation: "latin1_swedish_ci"
    t.text "Question", size: :long, null: false, collation: "latin1_swedish_ci"
    t.string "Respond", limit: 1, default: "N", null: false, collation: "latin1_swedish_ci"
    t.index ["Name"], name: "Name"
  end

  create_table "ff_farms", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "track_id", null: false
    t.index ["track_id"], name: "track_id", unique: true
  end

  create_table "ff_foalrecords", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.column "DC", "enum('B','I','C','S','P')", default: "B", null: false, collation: "latin1_swedish_ci"
    t.integer "Earnings", default: 0, null: false
    t.column "FlatSC", "enum('F','SC')", default: "F", null: false, collation: "latin1_swedish_ci"
    t.integer "Fourths", limit: 2, default: 0, null: false
    t.integer "Horse", limit: 3, default: 0, null: false
    t.integer "Points", limit: 2, default: 0, null: false
    t.integer "Seconds", limit: 2, default: 0, null: false
    t.integer "Stakes", limit: 2, default: 0, null: false
    t.integer "StakesFs", limit: 2, default: 0, null: false
    t.integer "StakesSds", limit: 2, default: 0, null: false
    t.integer "StakesTds", limit: 2, default: 0, null: false
    t.integer "StakesWn", limit: 2, default: 0, null: false
    t.integer "Starts", limit: 2, default: 0, null: false
    t.integer "Thirds", limit: 2, default: 0, null: false
    t.integer "Wins", limit: 2, default: 0, null: false
    t.index ["DC"], name: "DC"
    t.index ["Horse"], name: "Horse"
  end

  create_table "ff_futureentries", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.boolean "AutoEnter", default: false, null: false
    t.boolean "AutoShip", default: false, null: false
    t.datetime "DateEntered", precision: nil, null: false
    t.integer "Equipment", limit: 1
    t.integer "Horse", limit: 3, default: 0, null: false
    t.integer "Instructions", limit: 1
    t.integer "Jock2", limit: 1
    t.integer "Jock3", limit: 1
    t.integer "Jockey", limit: 1
    t.integer "Race", limit: 2, default: 0, null: false
    t.date "RaceDate"
    t.column "ShipMethod", "enum('R','A','*')", default: "R", null: false, collation: "latin1_swedish_ci"
    t.index ["Horse", "Race"], name: "HorseRace", unique: true
  end

  create_table "ff_futureevents", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.date "Date"
    t.string "Event", collation: "latin1_swedish_ci"
    t.integer "Horse", limit: 3
    t.index ["Event", "Date"], name: "event_search"
  end

  create_table "ff_futureshipping", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.date "Date", null: false
    t.integer "Horse", limit: 3, null: false
    t.column "Mode", "enum('R','A','*')", default: "R", null: false, collation: "latin1_swedish_ci", comment: "* = choose best method"
    t.integer "RaceLink", limit: 2
    t.column "Status", "enum('S','P','D')", default: "S", null: false, collation: "latin1_swedish_ci"
    t.integer "ToFarm", limit: 2
    t.integer "ToTrack", limit: 2
    t.index ["Horse", "ToTrack", "Date"], name: "Horse", unique: true
  end

  create_table "ff_horse_brankings", primary_key: "Horse", id: { type: :integer, limit: 3, default: nil }, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Foals", limit: 2, default: 0, null: false
    t.integer "Points", limit: 2, default: 0, null: false
    t.integer "Races", null: false
    t.integer "Ranking", limit: 2, null: false
    t.index ["Points"], name: "idx_points"
    t.index ["Ranking"], name: "idx_ranking"
  end

  create_table "ff_horse_bsrankings", primary_key: "Horse", id: { type: :integer, limit: 3, default: nil }, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Foals", limit: 2, default: 0, null: false
    t.integer "Points", limit: 2, default: 0, null: false
    t.integer "Races", null: false
    t.integer "Ranking", limit: 2, null: false
  end

  create_table "ff_horse_colors", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Abbr", limit: 5, null: false, collation: "latin1_swedish_ci"
    t.string "Color", null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_horse_comments", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "CommentID", limit: 1, default: 0, null: false
    t.integer "Horse", limit: 3, null: false
  end

  create_table "ff_horse_events", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "event", null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_horse_history", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.timestamp "date", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
    t.integer "eventId", limit: 1, null: false
    t.integer "horseId", null: false
    t.string "value", collation: "latin1_swedish_ci"
    t.index ["horseId", "eventId", "date"], name: "horseId", unique: true
  end

  create_table "ff_horse_injuries", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.date "Date", null: false
    t.integer "Horse", limit: 3, null: false
    t.integer "Injury", limit: 1, null: false
    t.string "Leg", limit: 2, collation: "latin1_swedish_ci"
    t.index ["Date", "Horse"], name: "date_horse"
    t.index ["Date"], name: "Date"
    t.index ["Horse", "Date"], name: "horse_date"
    t.index ["Horse", "Injury"], name: "Horse_2"
    t.index ["Horse"], name: "Horse"
    t.index ["Injury"], name: "Injury"
  end

  create_table "ff_horse_jockeys", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Happy", limit: 1, default: 0, null: false
    t.integer "Horse", limit: 3, default: 0, null: false
    t.integer "Jockey", limit: 2, default: 0, null: false
    t.integer "XP", limit: 1, default: 0, null: false
    t.index ["Horse", "Jockey"], name: "Horse"
  end

  create_table "ff_horse_latest_claiming_race", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.date "date", null: false
    t.integer "horse", null: false
    t.integer "race_id", null: false
    t.index ["horse"], name: "Horse", unique: true
    t.index ["race_id"], name: "race"
  end

  create_table "ff_horse_latest_injuries", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.date "Date", null: false
    t.integer "Horse", limit: 3, null: false
    t.integer "Injury", limit: 1, null: false
    t.string "Leg", limit: 2, collation: "latin1_swedish_ci"
    t.index ["Date", "Horse"], name: "date_horse"
    t.index ["Date"], name: "Date"
    t.index ["Horse", "Date"], name: "horse_date"
    t.index ["Horse", "Injury"], name: "Horse_2"
    t.index ["Horse"], name: "Horse", unique: true
    t.index ["Injury"], name: "Injury"
  end

  create_table "ff_horse_markings", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Marking", null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_horse_sales", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Buyer", limit: 2
    t.date "Date", null: false
    t.integer "Horse", limit: 3, null: false
    t.boolean "PT", default: true, null: false
    t.integer "Price", limit: 3
    t.integer "Seller", limit: 2
    t.index ["Buyer"], name: "Buyer"
    t.index ["Date", "Seller"], name: "Seller Date"
    t.index ["Date"], name: "Date"
    t.index ["Horse"], name: "Horse"
    t.index ["PT"], name: "PT"
    t.index ["Seller"], name: "Seller"
  end

  create_table "ff_horse_shipping", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.date "Arrive", null: false
    t.date "Date", null: false
    t.integer "FromFarm", limit: 2
    t.integer "FromTrack", limit: 2
    t.integer "Horse", limit: 3, null: false
    t.column "Mode", "enum('A','R')", null: false, collation: "latin1_swedish_ci"
    t.integer "ToFarm", limit: 2
    t.integer "ToTrack", limit: 2
    t.index ["Date"], name: "Date"
    t.index ["Horse"], name: "Horse"
  end

  create_table "ff_horse_status", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Status", null: false, collation: "latin1_swedish_ci"
    t.index ["Status"], name: "Status"
  end

  create_table "ff_horse_titles", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Abbr", limit: 10, null: false, collation: "latin1_swedish_ci"
    t.integer "Points", limit: 2, null: false
    t.string "Title", limit: 50, null: false, collation: "latin1_swedish_ci"
    t.index ["Abbr"], name: "Abbr"
    t.index ["Points"], name: "Points"
    t.index ["Title"], name: "Title"
  end

  create_table "ff_horses", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Acceleration", limit: 2
    t.string "Allele", limit: 50, collation: "latin1_swedish_ci"
    t.column "Approval", "enum('Y','N')", default: "N", collation: "latin1_swedish_ci"
    t.integer "Ave", limit: 2
    t.integer "BMBPF", limit: 1
    t.integer "BPF", limit: 1
    t.boolean "Boarded", default: false, null: false
    t.integer "Break", limit: 2
    t.integer "Breeder", limit: 2
    t.integer "Close", limit: 1
    t.integer "Color", limit: 1
    t.text "Comments", size: :long, collation: "latin1_swedish_ci"
    t.integer "Consistency", limit: 1
    t.integer "Courage", limit: 1
    t.float "CurrentHeight", limit: 53, default: 0.0, null: false
    t.string "DC", limit: 3, collation: "latin1_swedish_ci"
    t.date "DOB"
    t.date "DOD"
    t.integer "Dam"
    t.integer "DamDam"
    t.integer "DamSire"
    t.integer "DefaultEquip", limit: 1
    t.integer "DefaultInstructions", limit: 1
    t.integer "DefaultJock1", limit: 2
    t.integer "DefaultJock2", limit: 2
    t.integer "DefaultJock3", limit: 2
    t.integer "DefaultWorkoutTrack", limit: 2
    t.date "Die", null: false
    t.integer "Dirt", limit: 1
    t.string "DisplayEnergy", limit: 1, collation: "latin1_general_cs"
    t.string "DisplayFitness", limit: 1, collation: "latin1_general_cs"
    t.integer "EnergyCurrent", limit: 3
    t.integer "EnergyMin", limit: 1
    t.integer "EnergyRegain", limit: 1
    t.integer "Equipment", limit: 1
    t.boolean "FFMares", default: false, null: false
    t.integer "Face", limit: 1, default: 3
    t.integer "FacePic", limit: 1, default: 18
    t.integer "Fast", limit: 1
    t.integer "Fitness", limit: 1
    t.integer "FoalHeight", limit: 1
    t.integer "GenSound", limit: 1
    t.column "Gender", "enum('C','F','G','M','S')", collation: "latin1_swedish_ci"
    t.integer "Good", limit: 1
    t.date "HBDate"
    t.string "Hasbeen", limit: 2, collation: "latin1_swedish_ci"
    t.string "Height", limit: 4, collation: "latin1_swedish_ci"
    t.date "ImmDate"
    t.string "Immature", limit: 2, collation: "latin1_swedish_ci"
    t.boolean "InTransit", default: false, null: false
    t.integer "LFPic", limit: 1, default: 18
    t.integer "LFmarkings", limit: 1, default: 3
    t.integer "LHPic", limit: 1, default: 18
    t.integer "LHmarkings", limit: 1, default: 3
    t.integer "LastRaceFinishers"
    t.integer "LastRaceId"
    t.integer "Lead", limit: 1
    t.boolean "Leased", default: false, null: false
    t.integer "LoafPct", limit: 1, default: 0, null: false
    t.integer "LoafStride", limit: 2
    t.integer "LoafThresh", limit: 2
    t.integer "LocBred", limit: 2, default: 10, null: false
    t.integer "Location", limit: 2, default: 59, null: false
    t.integer "MaresPerStable", limit: 1, default: 0
    t.integer "Max", limit: 2
    t.integer "Midpack", limit: 1
    t.integer "Min", limit: 2
    t.float "NEGain", limit: 53
    t.integer "NELoss", limit: 1
    t.string "Name", limit: 18, collation: "utf8_general_ci"
    t.float "NaturalEnergy", limit: 53, default: 0.0, null: false
    t.integer "Outside", limit: 1, default: 0
    t.integer "Owner", limit: 2
    t.text "OwnerComments", size: :long, collation: "latin1_swedish_ci"
    t.integer "Pace", limit: 1
    t.integer "Pissy", limit: 2
    t.integer "RFPic", limit: 1, default: 18
    t.integer "RFmarkings", limit: 1, default: 3
    t.integer "RHPic", limit: 1, default: 18
    t.integer "RHmarkings", limit: 1, default: 3
    t.integer "RacesCount"
    t.integer "Ratability", limit: 2
    t.integer "RestDayCount"
    t.date "Retire", null: false
    t.integer "SC", limit: 1
    t.float "SPS", limit: 53
    t.integer "SalePrice", default: -1
    t.integer "SellTo", limit: 2, default: 0
    t.integer "Sire"
    t.integer "SireDam"
    t.integer "SireSire"
    t.integer "Slow", limit: 1
    t.integer "Soundness", limit: 1
    t.integer "Stamina", limit: 2
    t.integer "Status", limit: 1
    t.integer "StudPrice", limit: 3, default: -1
    t.integer "Sustain", limit: 1
    t.integer "Traffic", limit: 2
    t.integer "Turf", limit: 1
    t.integer "Turning", limit: 2
    t.integer "Weight", limit: 2
    t.integer "Wet", limit: 1
    t.integer "XPCurrent", limit: 1
    t.integer "XPRate", limit: 1
    t.boolean "can_be_sold", default: false, null: false
    t.timestamp "last_modified", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
    t.integer "leaser", default: 0
    t.string "slug", collation: "utf8_general_ci"
    t.index ["Boarded"], name: "Boarded"
    t.index ["Breeder"], name: "Breeder"
    t.index ["DC"], name: "DC"
    t.index ["DOB"], name: "DOB"
    t.index ["DOD"], name: "DOD"
    t.index ["Dam", "DOB"], name: "Dam_2"
    t.index ["Dam"], name: "Dam"
    t.index ["DamDam"], name: "DamDam"
    t.index ["DamSire"], name: "DamSire"
    t.index ["DefaultJock1"], name: "DefaultJock1"
    t.index ["DisplayEnergy", "EnergyCurrent"], name: "idx_energy_all"
    t.index ["DisplayEnergy"], name: "DisplayEnergy"
    t.index ["DisplayFitness", "Fitness"], name: "idx_fitness_all"
    t.index ["DisplayFitness"], name: "idx_display_fitness"
    t.index ["EnergyCurrent"], name: "EnergyCurrent"
    t.index ["Fitness"], name: "Fitness"
    t.index ["Fitness"], name: "idx_fitness"
    t.index ["Gender"], name: "Gender"
    t.index ["LastRaceId"], name: "LastRace"
    t.index ["Leased"], name: "Leased"
    t.index ["Location"], name: "Location"
    t.index ["Name"], name: "Name"
    t.index ["NaturalEnergy"], name: "NatEn"
    t.index ["Owner", "SalePrice"], name: "owner_price"
    t.index ["Owner"], name: "Owner"
    t.index ["SalePrice"], name: "SalePrice"
    t.index ["SellTo"], name: "SellTo"
    t.index ["Sire", "Dam"], name: "Sire_2"
    t.index ["Sire"], name: "Sire"
    t.index ["SireDam"], name: "SireDam"
    t.index ["SireSire"], name: "SireSire"
    t.index ["Status", "Location"], name: "status_location"
    t.index ["Status", "Owner", "Leased"], name: "Status_Owner_Leased"
    t.index ["Status", "Owner"], name: "Status_Owner"
    t.index ["Status", "Sire", "Dam"], name: "Status_2"
    t.index ["Status"], name: "Status"
    t.index ["leaser"], name: "Leaser"
  end

  create_table "ff_hoty_cats", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Name", null: false, collation: "latin1_swedish_ci"
    t.index ["Name"], name: "name", unique: true
  end

  create_table "ff_hoty_winners", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Category", limit: 1, default: 0, null: false
    t.integer "Winner", limit: 3, default: 0, null: false
    t.integer "Year", limit: 2, default: 0, null: false
    t.index ["Category"], name: "Category"
  end

  create_table "ff_injuries", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.date "Date"
    t.integer "Horse", limit: 3, default: 0, null: false
    t.integer "Injury", limit: 1
    t.date "Rest"
    t.date "VetDate"
  end

  create_table "ff_injury_types", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Injury", limit: 50, null: false, collation: "latin1_swedish_ci"
    t.string "Line", null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_jockey_instructions", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Instructions", null: false, collation: "latin1_swedish_ci"
    t.string "Text", null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_jockey_records", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Earnings", default: 0, null: false
    t.integer "Fourths", limit: 2, default: 0, null: false
    t.integer "Jockey", limit: 2, null: false
    t.integer "Seconds", limit: 2, default: 0, null: false
    t.integer "Stakes", limit: 2, default: 0, null: false
    t.integer "StakesFs", limit: 2, default: 0, null: false
    t.integer "StakesSds", limit: 2, default: 0, null: false
    t.integer "StakesTds", limit: 2, default: 0, null: false
    t.integer "StakesWn", limit: 2, default: 0, null: false
    t.integer "Starts", limit: 2, default: 0, null: false
    t.integer "Thirds", limit: 2, default: 0, null: false
    t.integer "Wins", limit: 2, default: 0, null: false
    t.integer "Year", null: false
  end

  create_table "ff_jockey_status", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Status", null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_jockeys", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Acceleration", limit: 1, default: 0, null: false
    t.integer "Ave", limit: 2, default: 0, null: false
    t.integer "Break", limit: 2, default: 0, null: false
    t.integer "Close", limit: 1, default: 0, null: false
    t.integer "Consistency", limit: 1, default: 0, null: false
    t.integer "Courage", limit: 1, default: 0, null: false
    t.date "DOB", null: false
    t.integer "Dirt", limit: 1, default: 0, null: false
    t.integer "Fast", limit: 1, default: 0, null: false
    t.string "First", null: false, collation: "latin1_swedish_ci"
    t.column "Gender", "enum('M','F')", default: "M", null: false, collation: "latin1_swedish_ci"
    t.integer "Good", limit: 1, default: 0, null: false
    t.integer "Height", limit: 1, default: 0, null: false
    t.string "Last", null: false, collation: "latin1_swedish_ci"
    t.integer "Lead", limit: 1, default: 0, null: false
    t.integer "LoafThresh", limit: 1, default: 0, null: false
    t.integer "Looking", limit: 1, default: 0, null: false
    t.integer "Max", limit: 2, default: 0, null: false
    t.integer "Midpack", limit: 1, default: 0, null: false
    t.integer "Min", limit: 2, default: 0, null: false
    t.integer "Pace", limit: 1, default: 0, null: false
    t.integer "Pissy", limit: 1, default: 0, null: false
    t.integer "Rating", limit: 1, default: 0, null: false
    t.integer "SC", limit: 1, default: 0, null: false
    t.integer "Slow", limit: 1, default: 0, null: false
    t.integer "Status", limit: 1, default: 1, null: false
    t.integer "Strength", limit: 1, default: 0, null: false
    t.integer "Traffic", limit: 1, default: 0, null: false
    t.integer "Turf", limit: 1, default: 0, null: false
    t.integer "Turning", limit: 2, default: 0, null: false
    t.integer "Weight", limit: 2, default: 0, null: false
    t.integer "Wet", limit: 1, default: 0, null: false
    t.integer "WhipSec", limit: 2, default: 0, null: false
    t.integer "XPCurrent", limit: 1, default: 0, null: false
    t.float "XPRate", limit: 53, default: 0.0, null: false
    t.string "slug", collation: "latin1_swedish_ci"
    t.index ["First"], name: "First"
    t.index ["Gender"], name: "Gender"
    t.index ["Last"], name: "Last"
    t.index ["Status"], name: "Status"
  end

  create_table "ff_jocklines", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Line", null: false, collation: "latin1_swedish_ci"
    t.string "Stat", null: false, collation: "latin1_swedish_ci"
    t.integer "Value", limit: 1
    t.index ["Stat", "Value"], name: "stat_search"
  end

  create_table "ff_leases", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.boolean "Active", default: false, null: false
    t.date "End"
    t.boolean "LeaserEnd", default: false, null: false
    t.date "LeaserEndDate"
    t.boolean "LeaserRefund", default: false, null: false
    t.boolean "OwnerEnd", default: false, null: false
    t.date "OwnerEndDate"
    t.boolean "OwnerRefund", default: false, null: false
    t.date "Start", null: false
    t.date "Terminated"
    t.integer "fee"
    t.integer "horse"
    t.integer "leaser"
    t.integer "owner"
    t.index ["horse", "Start", "End"], name: "horse_dates", unique: true
    t.index ["horse"], name: "horse"
    t.index ["leaser"], name: "Leaser"
  end

  create_table "ff_log_errors", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.timestamp "Date", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.text "Error_details", null: false
    t.string "Error_file", null: false
    t.integer "Error_line", limit: 3
    t.column "Error_type", "enum('DB','PHP')", default: "PHP", null: false
    t.integer "Skin", limit: 1
    t.integer "User", limit: 2
    t.index ["Error_type", "Error_file", "Error_line"], name: "Unique Error", unique: true
  end

  create_table "ff_log_quitting", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "auto_quit", limit: 1, default: 0, null: false
    t.integer "budget_amount", null: false
    t.text "horse_list", null: false, collation: "latin1_swedish_ci"
    t.date "quit_date", null: false
    t.integer "user_id", null: false
  end

  create_table "ff_log_sale_actions", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "action", limit: 50, null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_log_sales", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "action_id", default: 0, null: false
    t.boolean "active", default: true, null: false
    t.timestamp "date", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "horse", default: 0, null: false
    t.integer "price"
    t.integer "sellto"
    t.integer "user_id", null: false
    t.index ["horse", "date"], name: "horse_date"
    t.index ["horse", "price"], name: "horse_price"
    t.index ["horse", "sellto"], name: "horse_sellto"
    t.index ["price", "active"], name: "price_active"
    t.index ["sellto", "active"], name: "sellto_active"
  end

  create_table "ff_marking_images", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "image", limit: 25, null: false, collation: "latin1_swedish_ci"
    t.integer "marking_id", null: false
    t.index ["marking_id", "image"], name: "marking_id", unique: true
  end

  create_table "ff_nom_bs", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "BS", limit: 1, default: 0, null: false
    t.integer "Stable", limit: 2, default: 0, null: false
    t.index ["BS"], name: "series"
  end

  create_table "ff_nominations", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Horse", limit: 3, default: 0, null: false
    t.integer "Race", limit: 3, default: 0, null: false
    t.integer "Year", limit: 2
    t.index ["Race", "Horse", "Year"], name: "Race_Horse_Year", unique: true
    t.index ["Race", "Horse"], name: "Race_Horse"
    t.index ["Race"], name: "Race"
  end

  create_table "ff_nominations_sup", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "horse", limit: 3, null: false
    t.integer "race", limit: 2, null: false
    t.integer "year", limit: 2, null: false
    t.index ["race"], name: "race"
    t.index ["year"], name: "year"
  end

  create_table "ff_nomraces", primary_key: "ID", id: { type: :integer, unsigned: true }, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "2yo", limit: 3, unsigned: true
    t.integer "3yo", limit: 3, unsigned: true
    t.integer "3yo+", limit: 3, unsigned: true
    t.integer "4yo+", limit: 3, unsigned: true
    t.string "Period", limit: 1, default: "A", null: false, collation: "latin1_swedish_ci"
    t.integer "Race", limit: 2, default: 0, null: false, unsigned: true
    t.integer "Weanling", limit: 3, unsigned: true
    t.integer "Yearling", limit: 3, unsigned: true
    t.index ["Race"], name: "Race"
  end

  create_table "ff_odds", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.float "Dec", limit: 53, null: false
    t.string "Odds", limit: 5, null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_pedigrees", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "dam", limit: 18, null: false, collation: "latin1_swedish_ci"
    t.string "dam_dam", limit: 18, null: false, collation: "latin1_swedish_ci"
    t.string "dam_sire", limit: 18, null: false, collation: "latin1_swedish_ci"
    t.column "gender", "enum('M','F')", null: false, collation: "latin1_swedish_ci"
    t.string "horse", limit: 18, null: false, collation: "latin1_swedish_ci"
    t.string "sire", limit: 18, null: false, collation: "latin1_swedish_ci"
    t.string "sire_dam", limit: 18, null: false, collation: "latin1_swedish_ci"
    t.string "sire_sire", limit: 18, null: false, collation: "latin1_swedish_ci"
    t.integer "user_id", limit: 2, null: false
    t.index ["horse"], name: "horse", unique: true
  end

  create_table "ff_qual_horses", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "bc_places", default: 0
    t.integer "bc_points", default: 0
    t.integer "bc_shows", default: 0
    t.integer "bc_wins", default: 0
    t.integer "earnings", default: 0
    t.integer "fourths", default: 0
    t.integer "horse_id", limit: 3, null: false
    t.integer "places", default: 0
    t.integer "points", default: 0
    t.integer "race_id", limit: 2, null: false
    t.integer "shows", default: 0
    t.integer "stakes_fourths", default: 0
    t.integer "stakes_places", default: 0
    t.integer "stakes_shows", default: 0
    t.integer "stakes_wins", default: 0
    t.integer "wins", default: 0
    t.index ["horse_id", "race_id"], name: "horse_id", unique: true
  end

  create_table "ff_qual_races", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "race_id", limit: 2, null: false
  end

  create_table "ff_race_ages", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Age", limit: 10, null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_race_grades", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Abbr", limit: 5, null: false, collation: "latin1_swedish_ci"
    t.string "Grade", limit: 50, null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_race_types", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Type", limit: 50, null: false, collation: "latin1_swedish_ci"
    t.index ["Type"], name: "type"
  end

  create_table "ff_raceentries", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.timestamp "EntryDate", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "Equipment", limit: 1
    t.integer "Horse", limit: 3, default: 0, null: false
    t.integer "Instructions", limit: 1
    t.integer "Jock2", limit: 2
    t.integer "Jock3", limit: 2
    t.integer "Jockey", limit: 2
    t.integer "Odds", limit: 1
    t.integer "PP", limit: 1
    t.integer "Race", limit: 2, default: 0, null: false
    t.integer "Weight", limit: 2
    t.index ["Equipment"], name: "equipment"
    t.index ["Horse"], name: "Horse"
    t.index ["Race", "Horse"], name: "race_horse", unique: true
    t.index ["Race"], name: "race"
  end

  create_table "ff_racerecords", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.bigint "Earnings", default: 0, null: false
    t.column "FlatSC", "enum('F','SC')", default: "F", null: false, collation: "latin1_swedish_ci"
    t.integer "Fourths", limit: 1, default: 0, null: false
    t.integer "Horse", limit: 3, default: 0, null: false
    t.integer "Points", limit: 2, default: 0, null: false
    t.integer "Seconds", limit: 1, default: 0, null: false
    t.integer "Stakes", limit: 1, default: 0, null: false
    t.integer "StakesFs", limit: 1, default: 0, null: false
    t.integer "StakesSds", limit: 1, default: 0, null: false
    t.integer "StakesTds", limit: 1, default: 0, null: false
    t.integer "StakesWn", limit: 1, default: 0, null: false
    t.integer "Starts", limit: 1, default: 0, null: false
    t.integer "Thirds", limit: 1, default: 0, null: false
    t.integer "Wins", limit: 1, default: 0, null: false
    t.integer "Year", limit: 2, default: 0, null: false
    t.index ["Earnings"], name: "Earnings"
    t.index ["FlatSC"], name: "FlatSC"
    t.index ["Horse"], name: "Horse"
    t.index ["Points"], name: "Points"
    t.index ["StakesWn"], name: "StakesWn"
    t.index ["Wins"], name: "wins"
    t.index ["Year", "FlatSC"], name: "Year_FSC"
    t.index ["Year", "Horse"], name: "year_horse"
    t.index ["Year"], name: "Year"
  end

  create_table "ff_racerecords_allowance", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "horse", default: 0, null: false
    t.integer "wins", limit: 2, default: 0, null: false
    t.index ["horse"], name: "Horse", unique: true
    t.index ["wins"], name: "wins"
  end

  create_table "ff_racerecords_lifetime", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Earnings", default: 0, null: false
    t.integer "Fourths", limit: 1, default: 0, null: false
    t.integer "Horse", limit: 3, default: 0, null: false
    t.integer "Points", limit: 2, default: 0, null: false
    t.integer "Seconds", limit: 1, default: 0, null: false
    t.integer "Stakes", limit: 1, default: 0, null: false
    t.integer "StakesFs", limit: 1, default: 0, null: false
    t.integer "StakesSds", limit: 1, default: 0, null: false
    t.integer "StakesTds", limit: 1, default: 0, null: false
    t.integer "StakesWn", limit: 1, default: 0, null: false
    t.integer "Starts", limit: 1, default: 0, null: false
    t.integer "Thirds", limit: 1, default: 0, null: false
    t.integer "Wins", limit: 1, default: 0, null: false
    t.index ["Earnings"], name: "Earnings"
    t.index ["Horse"], name: "Horse", unique: true
    t.index ["Points"], name: "Points"
    t.index ["StakesWn"], name: "StakesWn"
    t.index ["Wins"], name: "wins"
  end

  create_table "ff_raceresults", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Age", limit: 2, default: 0, null: false
    t.integer "Condition", limit: 1, default: 0, null: false
    t.date "Date"
    t.float "Distance", limit: 53
    t.string "Gender", limit: 1, collation: "latin1_swedish_ci"
    t.integer "Grade", limit: 1
    t.integer "Location", limit: 2, default: 0, null: false
    t.integer "Num", limit: 1
    t.bigint "Purse"
    t.string "RaceName", limit: 50, collation: "latin1_swedish_ci"
    t.column "SplitType", "enum('4Q','2F')", default: "2F", null: false, collation: "latin1_swedish_ci"
    t.string "Time", limit: 10, collation: "latin1_swedish_ci"
    t.integer "Type", limit: 1, default: 0, null: false
    t.index ["Age"], name: "Age"
    t.index ["Condition"], name: "Surface"
    t.index ["Date"], name: "Date"
    t.index ["Distance"], name: "Distance"
    t.index ["Gender"], name: "Gender"
    t.index ["Grade"], name: "Grade"
    t.index ["Location"], name: "Location"
    t.index ["Num", "Date"], name: "Num_Date", unique: true
    t.index ["Num"], name: "RaceNum"
    t.index ["RaceName"], name: "RaceName"
    t.index ["Time"], name: "Time"
    t.index ["Type", "Date"], name: "Type_Date"
    t.index ["Type"], name: "Type"
  end

  create_table "ff_raceresults_oof", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Equip", limit: 1
    t.string "Fractions", collation: "latin1_swedish_ci"
    t.string "Horse", null: false, collation: "latin1_swedish_ci"
    t.integer "Jockey", limit: 2
    t.string "MarL", limit: 150, null: false, collation: "latin1_swedish_ci"
    t.integer "Odds", limit: 1
    t.integer "PP", limit: 1, null: false
    t.integer "Pos", limit: 1, default: 0, null: false
    t.string "RL", limit: 50, null: false, collation: "latin1_swedish_ci"
    t.integer "RaceID"
    t.integer "SF", limit: 2, default: 0, null: false
    t.integer "Weight", limit: 2
    t.index ["Equip"], name: "Equip"
    t.index ["Horse", "RaceID"], name: "Horse_Race"
    t.index ["Horse"], name: "Horse"
    t.index ["Pos", "Horse"], name: "position_horse"
    t.index ["Pos"], name: "Pos"
    t.index ["RaceID", "Horse"], name: "RaceID"
    t.index ["RaceID"], name: "RaceNum"
  end

  create_table "ff_races", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Age", limit: 2, null: false
    t.date "Date", null: false
    t.integer "DayNum", limit: 1, null: false
    t.float "Distance", limit: 53, null: false
    t.string "Gender", limit: 1, collation: "latin1_swedish_ci"
    t.integer "Grade", limit: 2
    t.integer "Location", limit: 1, null: false
    t.string "Name", collation: "latin1_swedish_ci"
    t.integer "Num", limit: 1
    t.bigint "Purse"
    t.integer "Type", limit: 1, null: false
    t.index ["Age"], name: "Age"
    t.index ["Date"], name: "Date"
    t.index ["Distance"], name: "Distance"
    t.index ["Grade"], name: "Grade"
    t.index ["Location"], name: "Track"
    t.index ["Location"], name: "location"
    t.index ["Name"], name: "Race"
    t.index ["Num"], name: "Num"
    t.index ["Purse"], name: "Purse"
    t.index ["Type"], name: "type"
  end

  create_table "ff_sctrials", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Comment", limit: 1, null: false
    t.integer "Condition", limit: 1, null: false
    t.date "Date", null: false
    t.integer "Distance", limit: 1, default: 0, null: false
    t.integer "Horse", limit: 3, default: 0, null: false
    t.integer "Jockey", limit: 2, default: 0, null: false
    t.integer "Location", limit: 2, default: 0, null: false
    t.string "Time", limit: 10, collation: "latin1_swedish_ci"
    t.index ["Horse", "Jockey", "Condition", "Location"], name: "Horse"
  end

  create_table "ff_shipping", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "ACost", limit: 3
    t.integer "ADay", limit: 1
    t.integer "AEn", limit: 1
    t.integer "AFit", limit: 1
    t.integer "End", limit: 1, default: 0, null: false
    t.integer "Miles", limit: 2, default: 0, null: false
    t.integer "RCost", limit: 3
    t.integer "RDay", limit: 1
    t.integer "REn", limit: 1
    t.integer "RFit", limit: 1
    t.integer "Start", limit: 1, default: 0, null: false
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
    t.index ["Start", "End"], name: "Start", unique: true
  end

  create_table "ff_shipping_old", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "ACost", limit: 3
    t.integer "ADay", limit: 1
    t.integer "AEn", limit: 1
    t.integer "AFit", limit: 1
    t.integer "End", limit: 1, default: 0, null: false
    t.integer "Miles", limit: 2, default: 0, null: false
    t.integer "RCost", limit: 3
    t.integer "RDay", limit: 1
    t.integer "REn", limit: 1
    t.integer "RFit", limit: 1
    t.integer "Start", limit: 1, default: 0, null: false
    t.index ["Start", "End"], name: "Start", unique: true
  end

  create_table "ff_skins", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.boolean "Active", default: false, null: false
    t.string "BackgroundImage", limit: 200, collation: "latin1_swedish_ci"
    t.text "Description", null: false, collation: "latin1_swedish_ci"
    t.string "MenuLink", limit: 6, default: "000", null: false, collation: "latin1_swedish_ci"
    t.string "PageBackground", limit: 6, null: false, collation: "latin1_swedish_ci"
    t.string "Skin", null: false, collation: "latin1_swedish_ci"
    t.string "TableHead", limit: 6, null: false, collation: "latin1_swedish_ci"
    t.string "TableRow1", limit: 6, null: false, collation: "latin1_swedish_ci"
    t.string "TableRow2", limit: 6, null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_speedrecords", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.float "Distance", limit: 53
    t.string "Gender", limit: 50, collation: "latin1_swedish_ci"
    t.string "Horse", limit: 25, default: "0", null: false, collation: "latin1_swedish_ci"
    t.string "NewRec", limit: 1, null: false, collation: "latin1_swedish_ci"
    t.integer "RaceID", limit: 3, default: 0, null: false
    t.string "Time", limit: 50, null: false, collation: "latin1_swedish_ci"
    t.string "Track", limit: 50, collation: "latin1_swedish_ci"
    t.index ["Distance"], name: "Distance"
    t.index ["Gender"], name: "Gender"
    t.index ["Horse"], name: "Horse"
    t.index ["RaceID"], name: "RaceID"
    t.index ["Time"], name: "Time"
    t.index ["Track"], name: "Track"
  end

  create_table "ff_stable_notes", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.timestamp "Created", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.boolean "Private", null: false
    t.integer "Stable", limit: 2, null: false
    t.text "Text", size: :long, collation: "latin1_swedish_ci"
    t.string "Title", null: false, collation: "latin1_swedish_ci"
    t.index ["Stable", "Created", "Title"], name: "Stable", unique: true
  end

  create_table "ff_stablerrs", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Fourth", limit: 2, default: 0, null: false
    t.integer "Money", default: 0, null: false
    t.integer "Place", limit: 2, default: 0, null: false
    t.integer "Races", limit: 2, default: 0, null: false
    t.integer "Shows", limit: 2, default: 0, null: false
    t.integer "Stable", limit: 3, default: 0, null: false
    t.integer "Win", limit: 2, default: 0, null: false
    t.integer "Year", limit: 2
    t.integer "stakes", limit: 2, default: 0, null: false
    t.integer "stakesfourth", limit: 2, default: 0, null: false
    t.integer "stakesplace", limit: 2, default: 0, null: false
    t.integer "stakesshow", limit: 2, default: 0, null: false
    t.integer "stakeswin", limit: 2, default: 0, null: false
    t.index ["Stable", "Year"], name: "stable_year", unique: true
    t.index ["Stable"], name: "Stable"
    t.index ["Year"], name: "Year"
  end

  create_table "ff_stables", id: :integer, default: nil, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "availableBalance", default: 0
    t.timestamp "date", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
    t.string "slug", collation: "latin1_swedish_ci"
    t.integer "totalBalance", default: 0
  end

  create_table "ff_tcbs_titles", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Title", null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_tcbs_winners", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "TCBS", limit: 2, null: false, collation: "latin1_swedish_ci"
    t.string "Title", limit: 50, null: false, collation: "latin1_swedish_ci"
    t.integer "Winner", limit: 3, default: 0, null: false
    t.integer "Year", limit: 2, default: 0, null: false
    t.index ["Title"], name: "Title"
  end

  create_table "ff_track_conditions", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Condition", null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_track_types", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Type", null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_track_weather", primary_key: "ID", id: :integer, default: nil, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "FFast", limit: 1, null: false
    t.integer "FGood", limit: 1, null: false
    t.integer "FSlow", limit: 1, null: false
    t.integer "FWet", limit: 1, null: false
    t.integer "SFast", limit: 1, null: false
    t.integer "SGood", limit: 1, null: false
    t.integer "SSlow", limit: 1, null: false
    t.integer "SWet", limit: 1, null: false
    t.integer "UFast", limit: 1, null: false
    t.integer "UGood", limit: 1, null: false
    t.integer "USlow", limit: 1, null: false
    t.integer "UWet", limit: 1, null: false
    t.integer "WFast", limit: 1, null: false
    t.integer "WGood", limit: 1, null: false
    t.integer "WSlow", limit: 1, null: false
    t.integer "WWet", limit: 1, null: false
  end

  create_table "ff_trackdata", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Abbr", limit: 5, null: false, collation: "latin1_swedish_ci"
    t.integer "Banking", limit: 1
    t.string "Condition", limit: 4, collation: "latin1_swedish_ci"
    t.string "DTSC", limit: 12, collation: "latin1_swedish_ci"
    t.integer "Jumps", limit: 1
    t.integer "Length", limit: 2
    t.string "Location", null: false, collation: "latin1_swedish_ci"
    t.string "Name", collation: "latin1_swedish_ci"
    t.integer "TurnDistance", limit: 2
    t.integer "TurnToFinish", limit: 2
    t.integer "Width", limit: 2
    t.index ["Condition"], name: "Condition"
    t.index ["DTSC"], name: "DTSC"
    t.index ["Location"], name: "Location"
    t.index ["Name"], name: "Name"
  end

  create_table "ff_training_schedule_details", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Activity1", limit: 1, null: false
    t.integer "Activity2", limit: 1
    t.integer "Activity3", limit: 1
    t.string "Day", limit: 1, null: false, collation: "latin1_swedish_ci"
    t.integer "Distance1", limit: 1, null: false
    t.integer "Distance2", limit: 1
    t.integer "Distance3", limit: 1
    t.integer "Schedule", limit: 2, null: false
    t.index ["Day"], name: "Day"
    t.index ["Schedule", "Day"], name: "Schedule"
  end

  create_table "ff_training_schedule_horses", primary_key: "Horse", id: { type: :integer, limit: 3, default: nil }, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Schedule", limit: 2, null: false
  end

  create_table "ff_training_schedules", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Description", collation: "latin1_swedish_ci"
    t.integer "Horse", limit: 3
    t.string "Name", collation: "latin1_swedish_ci"
    t.integer "Stable", limit: 2
    t.index ["Horse"], name: "horse"
    t.index ["Stable"], name: "stable"
  end

  create_table "ff_user_colors", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "MenuLink", limit: 6, null: false, collation: "latin1_swedish_ci"
    t.string "PageBackground", limit: 6, null: false, collation: "latin1_swedish_ci"
    t.string "TableHead", limit: 6, null: false, collation: "latin1_swedish_ci"
    t.string "TableRow1", limit: 6, null: false, collation: "latin1_swedish_ci"
    t.string "TableRow2", limit: 6, null: false, collation: "latin1_swedish_ci"
    t.integer "User", limit: 2, null: false
  end

  create_table "ff_user_ips", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "IP", limit: 50, null: false, collation: "latin1_swedish_ci"
    t.integer "User", limit: 2, default: 0, null: false
  end

  create_table "ff_user_styles", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Colt", limit: 6, default: "00F", null: false, collation: "latin1_swedish_ci"
    t.string "Filly", limit: 6, default: "F00", null: false, collation: "latin1_swedish_ci"
    t.string "FontSize", limit: 2, default: "10", null: false, collation: "latin1_swedish_ci"
    t.string "Gelding", limit: 6, default: "090", null: false, collation: "latin1_swedish_ci"
    t.string "Link", default: "text-decoration: none", null: false, collation: "latin1_swedish_ci"
    t.string "LinkActive", default: "text-decoration: none", null: false, collation: "latin1_swedish_ci"
    t.string "LinkHover", default: "text-decoration: none", null: false, collation: "latin1_swedish_ci"
    t.integer "Skin", limit: 1, default: 1, null: false
    t.integer "User", limit: 2, default: 0, null: false
    t.index ["Skin"], name: "Skin"
    t.index ["User", "Skin"], name: "User_2"
    t.index ["User"], name: "User", unique: true
  end

  create_table "ff_users", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.boolean "Admin", default: false, null: false
    t.boolean "Approval", default: false, null: false
    t.string "Birthday", limit: 5, collation: "utf8_general_ci"
    t.string "Birthyear", limit: 4, collation: "utf8_general_ci"
    t.integer "BugID"
    t.integer "Cheating", limit: 1, default: 0, null: false
    t.boolean "CreateAuction", default: true, null: false
    t.text "Description", size: :long
    t.string "Email", null: false
    t.boolean "EmailVal", default: false, null: false
    t.boolean "Emailed", default: false, null: false
    t.boolean "Flag", default: false
    t.date "FlagDate"
    t.integer "ForumID", limit: 2
    t.string "IP", null: false, collation: "utf8_general_ci"
    t.date "JoinDate", null: false
    t.datetime "LastBought", precision: nil
    t.datetime "LastEntry", precision: nil
    t.datetime "LastLogin", precision: nil
    t.datetime "LastMareBred", precision: nil
    t.datetime "LastSold", precision: nil
    t.datetime "LastStudBred", precision: nil
    t.integer "Level", limit: 1, default: 0, null: false, unsigned: true
    t.string "Name", null: false, collation: "utf8_general_ci"
    t.string "Password", limit: 100, collation: "utf8_bin"
    t.datetime "PrevLogin", precision: nil
    t.integer "RefID", limit: 3, default: 0, null: false
    t.string "StableName", null: false, collation: "utf8_general_ci"
    t.string "Status", limit: 3, default: "A", collation: "utf8_general_ci"
    t.integer "Timestamp", default: 0, null: false
    t.integer "TrackID", limit: 2
    t.integer "TrackMiles", limit: 1
    t.string "Username", limit: 25, collation: "utf8_bin"
    t.string "discourse_api_key"
    t.integer "discourse_id"
    t.string "discourse_name"
    t.timestamp "last_modified", default: -> { "CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" }, null: false
    t.string "slug", collation: "latin1_general_cs"
    t.integer "user_id"
    t.index ["Email"], name: "Email"
    t.index ["Email"], name: "email_unique", unique: true
    t.index ["ForumID"], name: "ForumID"
    t.index ["JoinDate"], name: "JoinDate"
    t.index ["LastBought"], name: "LastBought"
    t.index ["LastEntry"], name: "LastEntry"
    t.index ["LastLogin"], name: "LastLogin"
    t.index ["LastMareBred"], name: "LastMareBred"
    t.index ["LastSold"], name: "LastSold"
    t.index ["LastStudBred"], name: "LastStudBred"
    t.index ["Name"], name: "Name"
    t.index ["Password"], name: "Password"
    t.index ["StableName"], name: "StableName"
    t.index ["Status"], name: "Status"
    t.index ["Username"], name: "Username"
    t.index ["Username"], name: "username_unique", unique: true
  end

  create_table "ff_userwarnings", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.date "DateFulfilled"
    t.date "DateGiven"
    t.string "Type", collation: "latin1_swedish_ci"
    t.integer "User", limit: 2
  end

  create_table "ff_visitors", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.date "Date", null: false
    t.string "IP", null: false, collation: "latin1_swedish_ci"
    t.index ["IP", "Date"], name: "IP", unique: true
  end

  create_table "ff_visitors_log", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.date "Date", null: false
    t.integer "Visitors", limit: 2, default: 0, null: false
  end

  create_table "ff_weather", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Condition", limit: 1, null: false
    t.integer "Day", limit: 1, null: false
    t.integer "Rain", limit: 1, null: false
    t.integer "Track", limit: 2, null: false
  end

  create_table "ff_workout_bonuses", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Bonus", limit: 1, null: false
    t.integer "Horse", default: 0, null: false
    t.string "Stat", null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_workout_types", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "Type", null: false, collation: "latin1_swedish_ci"
  end

  create_table "ff_workouts", primary_key: "ID", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.integer "Activity1", limit: 1, null: false
    t.integer "Activity2", limit: 1
    t.integer "Activity3", limit: 1
    t.integer "Comment", limit: 1, null: false
    t.integer "Condition", limit: 1, null: false
    t.integer "DTSC", limit: 1, null: false
    t.date "Date", null: false
    t.integer "Distance1", limit: 1, default: 0, null: false
    t.integer "Distance2", limit: 1
    t.integer "Distance3", limit: 1
    t.integer "Effort", limit: 1, default: 0, null: false
    t.integer "Equipment", limit: 1
    t.integer "Horse", limit: 3, default: 0, null: false
    t.integer "Jockey", limit: 2, default: 0, null: false
    t.integer "Location", limit: 2, default: 0, null: false
    t.integer "Rank", limit: 2
    t.float "Time", limit: 53
    t.integer "confidence", default: 0
    t.index ["Date", "Location"], name: "date_location"
    t.index ["Date"], name: "date"
    t.index ["Horse", "Date"], name: "horse_date"
    t.index ["Horse"], name: "horse"
  end

  create_table "horse_broodmares_mv", primary_key: "horse_id", id: { type: :integer, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.string "allele", limit: 32
    t.integer "classic_level"
    t.string "classic_level_text"
    t.string "color", limit: 30
    t.integer "color_id"
    t.string "dam_dam_dosage", limit: 3
    t.integer "dam_dam_id"
    t.string "dam_dam_name", limit: 18
    t.string "dam_dosage", limit: 3
    t.integer "dam_id"
    t.string "dam_name", limit: 18
    t.string "dam_sire_dosage", limit: 3
    t.integer "dam_sire_id"
    t.string "dam_sire_name", limit: 18
    t.integer "dirt_level"
    t.string "dirt_level_text"
    t.string "dosage", limit: 3
    t.bigint "earnings", default: 0, null: false
    t.integer "endurance_level"
    t.string "endurance_level_text"
    t.float "height", limit: 53
    t.string "horse_name", limit: 18
    t.integer "points", default: 0, null: false
    t.string "race_record"
    t.integer "sc_level"
    t.string "sc_level_text"
    t.string "sire_dam_dosage", limit: 3
    t.integer "sire_dam_id"
    t.string "sire_dam_name", limit: 18
    t.string "sire_dosage", limit: 3
    t.integer "sire_id"
    t.string "sire_name", limit: 18
    t.string "sire_sire_dosage", limit: 3
    t.integer "sire_sire_id"
    t.string "sire_sire_name", limit: 18
    t.integer "sprint_level"
    t.string "sprint_level_text"
    t.integer "starts", default: 0, null: false
    t.string "title", limit: 5
    t.integer "turf_level"
    t.string "turf_level_text"
  end

  create_table "horse_parents_mv", primary_key: "horse_id", id: { type: :integer, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.integer "breed_ranking_id"
    t.string "breed_ranking_name", limit: 10
    t.integer "broodmare_sire_ranking_id"
    t.string "broodmare_sire_ranking_name", limit: 10
    t.integer "classic_count", limit: 2, default: 0, null: false
    t.integer "classic_level", limit: 2, default: 0, null: false
    t.string "classic_level_text", limit: 40, default: "Maiden"
    t.integer "classic_otb_count", limit: 2, default: 0, null: false
    t.integer "dirt_level", limit: 2, default: 0, null: false
    t.string "dirt_level_text", limit: 40, default: "Maiden"
    t.integer "dirt_otb_count", limit: 2, default: 0, null: false
    t.integer "dirt_runners_count", limit: 2, default: 0, null: false
    t.integer "endurance_count", limit: 2, default: 0, null: false
    t.integer "endurance_level", limit: 2, default: 0, null: false
    t.string "endurance_level_text", limit: 40, default: "Maiden"
    t.integer "endurance_otb_count", limit: 2, default: 0, null: false
    t.integer "fast_level", limit: 2, default: 0, null: false
    t.string "fast_level_text", limit: 40, default: "Maiden"
    t.integer "fast_otb_count", limit: 2, default: 0, null: false
    t.integer "fast_runners_count", limit: 2, default: 0, null: false
    t.integer "foal_count", limit: 2, default: 0, null: false
    t.integer "good_level", limit: 2, default: 0, null: false
    t.string "good_level_text", limit: 40, default: "Maiden"
    t.integer "good_otb_count", limit: 2, default: 0, null: false
    t.integer "good_runners_count", limit: 2, default: 0, null: false
    t.integer "millionaires_count", limit: 2, default: 0, null: false
    t.integer "multi_stakes_winners_count", limit: 2, default: 0, null: false
    t.integer "racers_count", limit: 2, default: 0, null: false
    t.integer "sc_level", limit: 2, default: 0, null: false
    t.string "sc_level_text", limit: 40, default: "Maiden"
    t.integer "sc_otb_count", limit: 2, default: 0, null: false
    t.integer "sc_runners_count", limit: 2, default: 0, null: false
    t.integer "slow_level", limit: 2, default: 0, null: false
    t.string "slow_level_text", limit: 40, default: "Maiden"
    t.integer "slow_otb_count", limit: 2, default: 0, null: false
    t.integer "slow_runners_count", limit: 2, default: 0, null: false
    t.integer "sprinters_count", limit: 2, default: 0, null: false
    t.integer "sprinters_level", limit: 2, default: 0, null: false
    t.string "sprinters_level_text", limit: 40, default: "Maiden"
    t.integer "sprinters_otb_count", limit: 2, default: 0, null: false
    t.integer "stakes_winners_count", limit: 2, default: 0, null: false
    t.integer "titled_horses_count", limit: 2, default: 0, null: false
    t.bigint "total_foal_earnings", default: 0, null: false
    t.integer "turf_level", limit: 2, default: 0, null: false
    t.string "turf_level_text", limit: 40, default: "Maiden"
    t.integer "turf_otb_count", limit: 2, default: 0, null: false
    t.integer "turf_runners_count", limit: 2, default: 0, null: false
    t.integer "wet_level", limit: 2, default: 0, null: false
    t.string "wet_level_text", limit: 40, default: "Maiden"
    t.integer "wet_otb_count", limit: 2, default: 0, null: false
    t.integer "wet_runners_count", limit: 2, default: 0, null: false
    t.integer "winners_count", limit: 2, default: 0, null: false
  end

  create_table "horse_racehorses_mv", id: false, charset: "utf8", force: :cascade do |t|
    t.integer "age", limit: 1
    t.integer "allowance_wins_count", default: 0, null: false
    t.integer "boarded", limit: 1, default: 0, null: false
    t.boolean "can_be_sold", default: false, null: false
    t.string "default_equipment", limit: 20, collation: "latin1_swedish_ci"
    t.integer "default_jockey", limit: 2
    t.string "energy_grade", limit: 1, collation: "latin1_general_cs"
    t.boolean "entered_to_race", default: false, null: false
    t.string "fitness_grade", limit: 1, collation: "latin1_general_cs"
    t.column "flat_steeplechase", "enum('F','SC')", default: "F", null: false, collation: "latin1_swedish_ci"
    t.column "gender", "enum('C','F','G','M','S')", collation: "latin1_swedish_ci"
    t.integer "horse_id", null: false
    t.string "horse_name", limit: 18
    t.boolean "in_transit", default: false, null: false
    t.date "injury_flag_expiration"
    t.integer "last_race_finishers", limit: 2
    t.integer "last_race_id"
    t.boolean "leased", default: false, null: false
    t.integer "leaser", default: 0
    t.integer "location", default: 0
    t.integer "owner", default: 0
    t.integer "races_count", limit: 2, default: 0, null: false
    t.integer "rest_days_count", limit: 2, default: 0, null: false
    t.integer "riding_instructions", limit: 2
    t.integer "second_jockey", limit: 2
    t.integer "third_jockey", limit: 2
    t.string "track_name"
    t.integer "wins_count", default: 0, null: false
    t.index ["horse_id"], name: "horse_id", unique: true
  end

  create_table "horse_stallions_mv", primary_key: "horse_id", id: { type: :integer, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.string "allele", limit: 32
    t.integer "classic_level", default: 0, null: false
    t.string "classic_level_text", default: "Unraced", null: false
    t.string "color", limit: 30
    t.integer "color_id"
    t.string "dam_dam_dosage", limit: 3
    t.integer "dam_dam_id"
    t.string "dam_dam_name", limit: 18
    t.string "dam_dosage", limit: 3
    t.integer "dam_id"
    t.string "dam_name", limit: 18
    t.string "dam_sire_dosage", limit: 3
    t.integer "dam_sire_id"
    t.string "dam_sire_name", limit: 18
    t.integer "dirt_level", default: 0, null: false
    t.string "dirt_level_text", default: "Unraced", null: false
    t.string "dosage", limit: 3
    t.bigint "earnings", default: 0, null: false
    t.integer "endurance_level", default: 0, null: false
    t.string "endurance_level_text", default: "Unraced", null: false
    t.float "height", limit: 53
    t.string "horse_name", limit: 18
    t.integer "points", default: 0, null: false
    t.string "race_record", default: "Unraced", null: false
    t.integer "sc_level", default: 0, null: false
    t.string "sc_level_text", default: "Unraced", null: false
    t.string "sire_dam_dosage", limit: 3
    t.integer "sire_dam_id"
    t.string "sire_dam_name", limit: 18
    t.string "sire_dosage", limit: 3
    t.integer "sire_id"
    t.string "sire_name", limit: 18
    t.string "sire_sire_dosage", limit: 3
    t.integer "sire_sire_id"
    t.string "sire_sire_name", limit: 18
    t.integer "sprint_level", default: 0, null: false
    t.string "sprint_level_text", default: "Unraced", null: false
    t.integer "starts", default: 0, null: false
    t.string "title", limit: 5
    t.integer "turf_level", default: 0, null: false
    t.string "turf_level_text", default: "Unraced", null: false
  end

  create_table "horse_training_schedules_mv", id: false, charset: "utf8", force: :cascade do |t|
    t.integer "age", limit: 1
    t.string "default_equipment", limit: 20, collation: "latin1_swedish_ci"
    t.integer "default_jockey", limit: 2
    t.integer "default_workout_track", limit: 2
    t.integer "energy_current", limit: 1
    t.string "energy_grade", limit: 1, collation: "latin1_general_cs"
    t.integer "fitness", limit: 1
    t.string "fitness_grade", limit: 1, collation: "latin1_general_cs"
    t.column "flat_steeplechase", "enum('F','SC')", default: "F", null: false, collation: "latin1_swedish_ci"
    t.column "gender", "enum('C','F','G','M','S')", collation: "latin1_swedish_ci"
    t.integer "horse_id", null: false
    t.string "horse_name", limit: 18
    t.date "latest_injury_date"
    t.boolean "leased", default: false, null: false
    t.integer "leaser", default: 0
    t.integer "owner", default: 0
    t.integer "race_entry_id"
    t.string "track_name", collation: "latin1_swedish_ci"
    t.integer "training_schedule_horse_id"
    t.integer "training_schedule_id"
    t.index ["horse_id"], name: "horse_id", unique: true
    t.index ["leaser", "leased"], name: "leaser_leased"
    t.index ["owner", "leased"], name: "owner_leased"
  end

  create_table "pending_retirements", id: { type: :integer, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.integer "horse_id"
  end

  create_table "user_alerts", id: :integer, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.date "activates_at", null: false
    t.date "dismissed_at"
    t.date "expires_at"
    t.text "message", size: :long, null: false
    t.date "read_at"
    t.integer "reference_id"
    t.string "reference_type"
    t.integer "user_id"
    t.index ["user_id", "activates_at"], name: "user_date"
    t.index ["user_id", "expires_at"], name: "user_expire"
  end

  create_table "user_preferences", primary_key: "user_id", id: { type: :integer, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.string "training_energy_minimum", limit: 1
  end

  create_table "users", id: { type: :bigint, unsigned: true }, charset: "utf8", collation: "utf8_unicode_ci", force: :cascade do |t|
    t.string "email"
    t.datetime "inserted_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.integer "legacy_user_id"
    t.string "password_hash"
    t.text "sessions"
    t.datetime "updated_at", precision: nil
    t.index ["legacy_user_id"], name: "legacy_user_id", unique: true
  end

  add_foreign_key "users", "ff_users", column: "legacy_user_id", primary_key: "ID", name: "users_ibfk_1", on_update: :cascade, on_delete: :cascade
end
