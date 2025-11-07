module Account
  class Budget < ApplicationRecord
    self.table_name = "budget_transactions"
    self.ignored_columns += ["old_id"]

    DEFAULT_SORT = "id desc".freeze
    ACTIVITY_TYPES = %w[
      sold_horse bought_horse bred_mare bred_stud claimed_horse entered_race
      shipped_horse race_winnings jockey_fee nominated_racehorse nominated_stallion
      boarded_horse opening_balance paid_tax handicapping_races nominated_breeders_series
      consigned_auction leased_horse color_war activity_points donation won_breeders_series
      misc
    ].freeze
    SALES_ACTIVITIES = %w[sold_horse bought_horse claimed_horse consigned_auction leased_horse].freeze
    BREEDING_ACTIVITIES = %w[bred_mare bred_stud].freeze
    RACING_ACTIVITIES = %w[entered_race race_winnings jockey_fee won_breeders_series]
    NOMINATING_ACTIVITIES = %w[nominated_racehorse nominated_stallion nominated_breeders_series]
    GAME_ACTIVITIES = %w[opening_balance paid_tax handicapping_races color_war activity_points]
    MISC_ACTIVITIES = %w[misc donation]

    belongs_to :stable

    validates :amount, :balance, :description, presence: true
    validates :amount, :balance, numericality: { only_integer: true }

    scope :recent, -> { order(created_at: :desc) }
    scope :credit, -> { where(amount: 0..) }
    scope :debit, -> { where(amount: ...0) }
    scope :with_desc, ->(value) { where("description ILIKE ?", "%#{value}%") }

    def self.budget_category(category)
      case category.to_s.downcase
      when "sold_or_bought"
        where(activity_type: SALES_ACTIVITIES)
      when "all_breeding"
        where(activity_type: BREEDING_ACTIVITIES)
      when "all_racing"
        where(activity_type: RACING_ACTIVITIES)
      when "all_nominations"
        where(activity_type: NOMINATING_ACTIVITIES)
      when "game_activity"
        where(activity_type: GAME_ACTIVITIES)
      when "misc"
        where(activity_type: MISC_ACTIVITIES)
      else
        where(activity_type: category)
      end
    end

    def self.budget_description(value)
      if value.include?("\"")
        with_desc(value.tr('"', ""))
      else
        query = nil
        value.split(" ").each do |word|
          query = if query
            query.or(with_desc(word))
          else
            with_desc(word)
          end
        end
        query
      end
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[activity_type amount balance description created_at updated_at]
    end

    def self.ransackable_associations(_auth_object = nil)
      []
    end

    def self.ransackable_scopes(auth_object = nil)
      %w[budget_category budget_description]
    end
  end
end

# == Schema Information
#
# Table name: budget_transactions
# Database name: primary
#
#  id                                                                                                                                                                                           :bigint           not null, primary key
#  activity_type(sold_horse, bought_horse, bred_mare, bred_stud, claimed_horse, entered_race, shipped_horse, race_winnings, jockey_fee, nominated_racehorse, nominated_stallion, boarded_horse) :enum             indexed
#  amount                                                                                                                                                                                       :integer          default(0), not null
#  balance                                                                                                                                                                                      :integer          default(0), not null
#  description                                                                                                                                                                                  :text             not null, indexed
#  created_at                                                                                                                                                                                   :datetime         not null
#  updated_at                                                                                                                                                                                   :datetime         not null
#  legacy_budget_id                                                                                                                                                                             :integer          default(0), indexed
#  legacy_stable_id                                                                                                                                                                             :integer          default(0), indexed
#  stable_id                                                                                                                                                                                    :bigint           not null, indexed
#
# Indexes
#
#  index_budget_transactions_on_activity_type     (activity_type)
#  index_budget_transactions_on_description       (description)
#  index_budget_transactions_on_legacy_budget_id  (legacy_budget_id)
#  index_budget_transactions_on_legacy_stable_id  (legacy_stable_id)
#  index_budget_transactions_on_old_id            (old_id)
#  index_budget_transactions_on_stable_id         (stable_id)
#
# Foreign Keys
#
#  fk_rails_...  (stable_id => stables.id) ON DELETE => cascade ON UPDATE => cascade
#

