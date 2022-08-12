FactoryBot.define do
  factory :legacy_user do
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

