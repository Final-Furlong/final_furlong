FactoryBot.define do
  factory :stable, class: "Account::Stable" do
    name { "#{SecureRandom.alphanumeric(20)} #{SecureRandom.alphanumeric(10)} Stable" }
    user { association :user, stable: instance }
    legacy_id { rand(1..999_999) }
  end
end

# == Schema Information
#
# Table name: stables
# Database name: primary
#
#  id                :bigint           not null, primary key
#  available_balance :bigint           default(0), indexed
#  description       :text
#  last_online_at    :datetime         indexed
#  miles_from_track  :integer          default(10), not null
#  name              :string           not null
#  slug              :string           indexed
#  total_balance     :bigint           default(0), indexed
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  legacy_id         :integer          indexed
#  public_id         :string(12)       indexed
#  racetrack_id      :bigint           indexed
#  user_id           :bigint           not null, uniquely indexed
#
# Indexes
#
#  index_stables_on_available_balance  (available_balance)
#  index_stables_on_last_online_at     (last_online_at)
#  index_stables_on_legacy_id          (legacy_id)
#  index_stables_on_name               (lower((name)::text)) UNIQUE
#  index_stables_on_old_racetrack_id   (old_racetrack_id)
#  index_stables_on_public_id          (public_id)
#  index_stables_on_racetrack_id       (racetrack_id)
#  index_stables_on_slug               (slug)
#  index_stables_on_total_balance      (total_balance)
#  index_stables_on_user_id            (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (racetrack_id => racetracks.id) ON DELETE => nullify ON UPDATE => cascade
#  fk_rails_...  (user_id => users.id) ON DELETE => restrict ON UPDATE => cascade
#

