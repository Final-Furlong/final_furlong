module Breeding
  class Slot < ApplicationRecord
    self.table_name = "breeding_slots"

    has_many :breedings, class_name: "Horses::Breeding", dependent: :nullify

    validates :month, :start_day, :end_day, presence: true
    validates :end_day, comparison: { other_than: :start_day }
    validates :end_day, uniqueness: { scope: %i[month start_day] }

    scope :ordered, -> { order(month: :asc, start_day: :asc) }
    scope :missed, -> { where("month < :month OR (month = :month AND :day < end_day)", { month: Date.current.month, day: Date.current.day }) }
    scope :not_missed, -> { where("month > :month OR (month = :month AND end_day > :day)", { month: Date.current.month, day: Date.current.day }) }

    def to_s
      date.strftime("%b %-d")
    end

    def end_day
      (month == 2 && !Date.current.leap?) ? super - 1 : super
    end

    def start_date
      Date.new(Date.current.year, month, start_day)
    end

    def date
      Date.new(Date.current.year, month, end_day)
    end

    def past?
      Date.current > date
    end
  end
end

# == Schema Information
#
# Table name: breeding_slots
# Database name: primary
#
#  id         :bigint           not null, primary key
#  end_day    :integer          not null, indexed, uniquely indexed => [month, start_day]
#  month      :integer          not null, indexed, uniquely indexed => [start_day, end_day]
#  start_day  :integer          not null, uniquely indexed => [month, end_day], indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_breeding_slots_on_end_day                          (end_day)
#  index_breeding_slots_on_month                            (month)
#  index_breeding_slots_on_month_and_start_day_and_end_day  (month,start_day,end_day) UNIQUE
#  index_breeding_slots_on_start_day                        (start_day)
#

