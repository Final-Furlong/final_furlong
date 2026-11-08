class UpdateBreedersSeries4yoDirtQualifiersToVersion3 < ActiveRecord::Migration[8.1]
  def change
    update_view :breeders_series_4yo_dirt_qualifiers,
      version: 3,
      revert_to_version: 2,
      materialized: { side_by_side: true }
  end
end

