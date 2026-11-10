class UpdateBreedersSeries4yoDirtQualifiersToVersion4 < ActiveRecord::Migration[8.1]
  def change
    update_view :breeders_series_4yo_dirt_qualifiers,
      version: 4,
      revert_to_version: 3,
      materialized: { side_by_side: true }
  end
end

