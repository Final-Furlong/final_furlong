class Horses::Horse::Broodmare < ActiveRecord::AssociatedObject
  record.has_one :broodmare_foal_record, inverse_of: :mare, dependent: :delete

  def breed_ranking_string
    record.broodmare_foal_record.breed_ranking_string
  end
end

