class Horses::Horse::Stud < ActiveRecord::AssociatedObject
  record.has_one :stud_foal_record, inverse_of: :stud, dependent: :delete

  def breed_ranking_string
    record.stud_foal_record.breed_ranking_string
  end
end

