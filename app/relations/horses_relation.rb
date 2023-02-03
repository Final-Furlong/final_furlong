class HorsesRelation < ROM::Relation[:sql]
  gateway :default

  schema(:horses, infer: true) do
    attribute :status, Types::Strict::String.enum(**HorseStatus::STATUSES.values)
    attribute :gender, Types::Strict::String.enum(**HorseGender::GENDERS.values)

    associations do
      belongs_to :stable, as: :breeder, foreign_key: :breeder_id
      belongs_to :stable, as: :owner, foreign_key: :owner_id
      belongs_to :horse, as: :sire, foreign_key: :sire_id
      belongs_to :horse, as: :dam, foreign_key: :dam_id
      belongs_to :location, as: :location_bred, foreign_key: :location_bred_id
    end
  end

  def all
    select(:id, :name).order(:id)
  end

  # def born
  #   select(:id, :name)
  # end
  # scope :born, -> { not_unborn }
  # scope :living, -> { where(status: HorseStatus::LIVING_STATUSES) }
  # scope :all_retired, -> { where(status: HorseStatus::RETIRED_STATUSES) }
  # scope :ordered, -> { order(name: :asc) }
  # scope :owned_by, ->(stable) { where(owner: stable) }
  # scope :sort_by_status_asc, -> { in_order_of(:status, status_array_order) }

end

