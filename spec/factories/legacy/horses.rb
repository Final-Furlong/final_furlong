FactoryBot.define do
  factory :legacy_horse, class: "Legacy::Horse" do
    Breeder factory: :legacy_user
    ID { Faker::Number.number(digits: 3) }
    can_be_sold { false }
    last_modified { Time.current }
    rails_id { SecureRandom.uuid }
    Gender { "M" }
    DOB { 4.years.ago }
    Retire { 2.years.from_now }
    Die { 5.years.from_now }
    Status { 3 }
    LocBred { create(:legacy_racetrack).ID }
  end
end

# == Schema Information
#
# Table name: ff_users
#
#  Admin              :boolean          default(FALSE), not null
#  Approval           :boolean          default(FALSE), not null
#  Birthday           :string(5)
#  Birthyear          :string(4)
#  BugID              :integer
#  Cheating           :integer          default(0), not null
#  CreateAuction      :boolean          default(TRUE), not null
#  Description        :text(4294967295)
#  Email              :string(255)      not null, indexed, uniquely indexed
#  EmailVal           :boolean          default(FALSE), not null
#  Emailed            :boolean          default(FALSE), not null
#  Flag               :boolean          default(FALSE)
#  FlagDate           :date
#  ForumID            :integer          indexed
#  ID                 :integer          not null, primary key
#  IP                 :string(255)
#  JoinDate           :date             default(NULL), not null, indexed
#  LastBought         :datetime         indexed
#  LastEntry          :datetime         indexed
#  LastLogin          :datetime         indexed
#  LastMareBred       :datetime         indexed
#  LastSold           :datetime         indexed
#  LastStudBred       :datetime         indexed
#  Level              :integer          default(0), unsigned, not null
#  Name               :string(255)      not null, indexed
#  Password           :string(100)      indexed
#  PrevLogin          :datetime
#  RefID              :integer          default(0), not null
#  StableName         :string(255)      not null, indexed
#  Status             :string(3)        default("A"), indexed
#  Timestamp          :integer          default(0), not null
#  TrackID            :integer
#  TrackMiles         :integer
#  Username           :string(25)       indexed, uniquely indexed
#  discourse_api_key  :string(255)
#  discourse_name     :string(255)
#  last_modified      :datetime         not null
#  rails_activated_at :datetime
#  slug               :string(255)
#  discourse_id       :integer
#  user_id            :integer
#
# Indexes
#
#  Email            (Email)
#  ForumID          (ForumID)
#  JoinDate         (JoinDate)
#  LastBought       (LastBought)
#  LastEntry        (LastEntry)
#  LastLogin        (LastLogin)
#  LastMareBred     (LastMareBred)
#  LastSold         (LastSold)
#  LastStudBred     (LastStudBred)
#  Name             (Name)
#  Password         (Password)
#  StableName       (StableName)
#  Status           (Status)
#  Username         (Username)
#  email_unique     (Email) UNIQUE
#  username_unique  (Username) UNIQUE
#

