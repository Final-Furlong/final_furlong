module Game
  class Activity < ApplicationRecord
    self.table_name = "game_activity_points"

    ACTIVITY_TYPES = %w[
      color_war
      auction
      selling
      buying
      breeding
      claiming
      entering
      redeem
    ].freeze

    validates :activity_type, :first_year_points, :second_year_points, :older_year_points, presence: true
    validates :activity_type, inclusion: { in: ACTIVITY_TYPES }
    validates :first_year_points, :second_year_points, :older_year_points, numericality: { only_integer: true }
  end
end

# == Schema Information
#
# Table name: game_activity_points
# Database name: primary
#
#  id                                                                                       :bigint           not null, primary key
#  activity_type(color_war, auction, selling, buying, breeding, claiming, entering, redeem) :enum             not null, indexed
#  first_year_points                                                                        :integer          default(0), not null
#  older_year_points                                                                        :integer          default(0), not null
#  second_year_points                                                                       :integer          default(0), not null
#  created_at                                                                               :datetime         not null
#  updated_at                                                                               :datetime         not null
#
# Indexes
#
#  index_game_activity_points_on_activity_type  (activity_type)
#

