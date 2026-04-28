# frozen_string_literal: true

class PopulateTotalBookedCountInStallionOptions < ActiveRecord::Migration[8.1]
  def up
    Horses::Horse.stud.where.associated(:stud_options).find_each do |stud|
      total_booked_count = stud.breedings.current_year.taken.count
      stud.stud_options.update(total_booked_count:)
    end
  end

  def down
    Horses::Horse.stud.where.associated(:stud_options).find_each do |stud|
      stud.stud_options.update(total_booked_count: 0)
    end
  end
end

