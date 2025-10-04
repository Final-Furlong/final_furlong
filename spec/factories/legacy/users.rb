FactoryBot.define do
  factory :legacy_user, class: "Legacy::User" do
    Username { Faker::Internet.username }
    Password { Faker::Internet.password }
    Status { "A" }
    Name { Faker::Name.first_name }
    Email { Faker::Internet.email }
    Admin { false }
    RefID { 1 }
    JoinDate { Date.current }
    IP { Faker::Internet.public_ip_v4_address }
    Description { "foo" }

    after(:build) do |user|
      user.StableName = "#{user.username} Stable"
    end
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
#  JoinDate           :date             not null, indexed
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
#  rails_id           :string(36)
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

