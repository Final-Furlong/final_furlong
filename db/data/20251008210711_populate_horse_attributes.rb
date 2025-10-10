class PopulateHorseAttributes < ActiveRecord::Migration[8.0]
  def up
    Horses::Horse.where("date_of_birth != date_of_death").find_each do |horse|
      horse_age = horse.date_of_death.present? ? horse.date_of_death.year - horse.date_of_birth.year : Date.current.year - horse.date_of_birth.year
      ha = horse.horse_attributes || Horses::Attributes.new(horse:)
      ha.update!(age: horse_age)
    end
  end

  def down
    Horse::Attribute.delete_all
  end
end

