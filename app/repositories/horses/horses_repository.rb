module Horses
  class HorsesRepository < ApplicationRepository
    def initialize(model: Horse, scope: nil)
      @model = model
      super(model:, scope:)
    end

    def born
      scope.where.not(status: Status::STATUSES[:unborn])
    end

    def racehorse
      scope.where(status: Status::STATUSES[:racehorse])
    end

    def without_training_schedules
      scope.where.missing(:training_schedule)
    end

    def with_training_schedule(schedule)
      scope.joins(:training_schedule).where(training_schedule: { id: schedule })
    end

    def living
      scope.where(status: Status::LIVING_STATUSES)
    end

    def all_retired
      scope.where(status: Status::RETIRED_STATUSES)
    end

    def ordered
      scope.order(name: :asc)
    end

    def owned_by(stable)
      scope.where(owner: stable)
    end

    def sort_by_status_asc
      scope.in_order_of(:status, status_array_order)
    end

    private

    def status_array_order
      localized_statuses.sort.map { |_key, value| value }
    end

    def localized_statuses
      Horse.statuses.transform_keys { |key| Horse.human_attribute_name("status.#{key}") }
    end
  end
end

