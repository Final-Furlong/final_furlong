module Horses
class Horse < ApplicationModel
  attribute :age, Types::Integer
  attribute :breeder_id, Types::UUID
  attribute :dam_id, Types::UUID
  attribute :date_of_birth, Tupes::DateTime
  attribute :date_of_death, Tupes::DateTime
  attribute :foals_count, Types::Integer
  attribute :gender, Types::String
  attribute :legacy_id, Types::Integer
  attribute :location_bred_id, Types::UUID
  attribute :name, Types::String
  attribute :owner_id, Types::UUID
  attribute :sire_id, Types::UUID
  attribute :status, Types::String
  attribute :unborn_foals_count, Types::Integer

  attribute :created_at, Tupes::DateTime
  attribute :updated_at, Tupes::DateTime
end
