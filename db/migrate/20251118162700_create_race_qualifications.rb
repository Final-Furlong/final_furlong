class CreateRaceQualifications < ActiveRecord::Migration[8.1]
  def change
    create_view :race_qualifications, materialized: true
  end
end

