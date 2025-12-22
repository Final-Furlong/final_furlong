class Auction < ApplicationRecord
  include PublicIdGenerator
  include FriendlyId

  self.ignored_columns += ["old_id"]

  friendly_id :title, use: [:slugged, :finders]

  MINIMUM_DELAY = 7
  MINIMUM_DURATION = 7
  MAXIMUM_DURATION = 14
  MAX_AUCTIONS_PER_STABLE = 2
  HORSE_STATUSES = %w[racehorse broodmare stud yearling weanling].freeze

  belongs_to :auctioneer, class_name: "Account::Stable"
  has_many :horses, class_name: "Auctions::Horse", dependent: :destroy
  has_many :bids, class_name: "Auctions::Bid", dependent: :delete_all
  has_many :consignment_configs, class_name: "Auctions::ConsignmentConfig", dependent: :delete_all

  after_commit :schedule_deletion, on: %i[create update]
  after_commit :unschedule_deletion, on: :destroy
  after_commit :unconsign_legacy_horses, on: :destroy

  validates :start_time, :end_time, :hours_until_sold, :title, :horses_count,
    :sold_horses_count, :pending_sales_count, presence: true
  validates :title, length: { in: 10..500 }
  validates :title, uniqueness: { case_sensitive: false }
  validates :broodmare_allowed, :outside_horses_allowed, :racehorse_allowed_2yo,
    :racehorse_allowed_3yo, :racehorse_allowed_older, :reserve_pricing_allowed,
    :stallion_allowed, :weanling_allowed, :yearling_allowed, inclusion: { in: [true, false] }
  validates :start_time, comparison: { greater_than_or_equal_to: :today_plus_min_duration }
  validates :end_time, comparison: { greater_than_or_equal_to: :start_time_plus_min_duration }, if: :start_time
  validates :end_time, comparison: { less_than_or_equal_to: :start_time_plus_max_duration }, if: :start_time
  validates :horse_purchase_cap_per_stable, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :hours_until_sold, numericality: { only_integer: true, greater_than_or_equal_to: 12, less_than_or_equal_to: 48 }, allow_nil: true
  validates :spending_cap_per_stable, numericality: { only_integer: true, greater_than_or_equal_to: 10_000 }, allow_nil: true
  validate :minimum_status_required
  validate :final_furlong_only, on: :auto_create

  scope :current, -> { where(start_time: ..Time.current, end_time: Time.current..) }
  scope :upcoming, -> { where("start_time > ?", Time.current) }
  scope :past, -> { where(end_time: ..Time.current) }
  scope :by_auctioneer, ->(auctioneer) { where(auctioneer:) }
  scope :outside_horses_allowed, -> { where(outside_horses_allowed: true) }
  scope :valid_for_horse, ->(horse) {
    return none unless HORSE_STATUSES.include?(horse.status)
    query = case horse.status
    when "racehorse"
      case horse.age.to_i
      when 2
        where(racehorse_allowed_2yo: true)
      when 3
        where(racehorse_allowed_3yo: true)
      else
        where(racehorse_allowed_older: true)
      end
    when "broodmare"
      where(broodmare_allowed: true)
    when "stud"
      where(stallion_allowed: true)
    when "yearling"
      where(yearling_allowed: true)
    when "weanling"
      where(weanling_allowed: true)
    end

    query.by_auctioneer(horse.owner)
      .or(query.where(outside_horses_allowed: true))
  }

  def to_key = [slug]

  def active?
    DateTime.current.between?(start_time, end_time)
  end

  def ended?
    DateTime.current >= end_time
  end

  def future?
    start_time > DateTime.current
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[auctioneer_id end_time outside_horses_allowed start_time title]
  end

  def self.ransackable_scopes(_auth_object = nil)
    %i[current upcoming]
  end

  private

  def schedule_deletion
    unschedule_deletion
    schedule_job
  end

  def unschedule_deletion
    deletion_job.destroy_all if deletion_job.exists?
  end

  def unconsign_legacy_horses
    Legacy::Horse.where(consigned_auction_id: id).find_each do |horse|
      horse.consigned_auction_id = nil
      horse.save(validate: false)
    end
  end

  def deletion_job
    SolidQueue::Job.scheduled.where(class_name: "Daily::DeleteCompletedAuctionsJob").where("arguments LIKE ?", "%#{global_id_string}%")
  end

  def schedule_job
    Daily::DeleteCompletedAuctionsJob.set(wait_until: end_time + 1.minute).perform_later(auction: self)
  end

  def today_plus_min_duration
    (Date.current + MINIMUM_DELAY.days).beginning_of_day
  end

  def start_time_plus_min_duration
    start_time + MINIMUM_DURATION.days
  end

  def start_time_plus_max_duration
    start_time + MAXIMUM_DURATION.days
  end

  def minimum_status_required
    return if broodmare_allowed || racehorse_allowed_2yo || racehorse_allowed_3yo ||
      racehorse_allowed_older || stallion_allowed || weanling_allowed || yearling_allowed

    errors.add(:base, :status_required)
  end

  def final_furlong_only
    return if auctioneer.blank?
    return if auctioneer.name == "Final Furlong"

    errors.add(:auctioneer, :invalid)
  end
end

# == Schema Information
#
# Table name: auctions
# Database name: primary
#
#  id                            :bigint           not null, primary key
#  broodmare_allowed             :boolean          default(FALSE), not null
#  end_time                      :datetime         not null, indexed
#  horse_purchase_cap_per_stable :integer
#  horses_count                  :integer          default(0), not null
#  hours_until_sold              :integer          default(12), not null
#  outside_horses_allowed        :boolean          default(FALSE), not null
#  pending_sales_count           :integer          default(0), not null
#  racehorse_allowed_2yo         :boolean          default(FALSE), not null
#  racehorse_allowed_3yo         :boolean          default(FALSE), not null
#  racehorse_allowed_older       :boolean          default(FALSE), not null
#  reserve_pricing_allowed       :boolean          default(FALSE), not null
#  slug                          :string           uniquely indexed
#  sold_horses_count             :integer          default(0), not null
#  spending_cap_per_stable       :integer
#  stallion_allowed              :boolean          default(FALSE), not null
#  start_time                    :datetime         not null, indexed
#  title                         :string(500)      not null
#  weanling_allowed              :boolean          default(FALSE), not null
#  yearling_allowed              :boolean          default(FALSE), not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  auctioneer_id                 :bigint           not null, indexed
#  public_id                     :string(12)
#
# Indexes
#
#  index_auctions_on_auctioneer_id  (auctioneer_id)
#  index_auctions_on_end_time       (end_time)
#  index_auctions_on_slug           (slug) UNIQUE
#  index_auctions_on_start_time     (start_time)
#  index_auctions_on_title          (lower((title)::text)) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (auctioneer_id => stables.id) ON DELETE => cascade ON UPDATE => cascade
#

