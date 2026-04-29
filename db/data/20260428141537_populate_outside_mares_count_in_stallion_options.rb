# frozen_string_literal: true

class PopulateOutsideMaresCountInStallionOptions < ActiveRecord::Migration[8.1]
  def up
    Horses::Horse.stud.where.associated(:stud_options).find_each do |stud|
      outside_mares_count = stud.breedings.current_year.taken.joins(:mare).where.not(mare: { manager_id: stud.manager_id }).count
      stud.stud_options.update(outside_mares_count:)
    end
  end

  def down
    Horses::Horse.stud.where.associated(:stud_options).find_each do |stud|
      stud.stud_options.update(outside_mares_count: 0)
    end
  end
end

