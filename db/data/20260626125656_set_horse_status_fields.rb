# frozen_string_literal: true

class SetHorseStatusFields < ActiveRecord::Migration[8.1]
  def up
    # rubocop:disable Rails/SkipsModelValidations
    Horses::Horse.update_all(type: "Horses::Horse::Foal")
    Horses::Horse.where(age: 2.., status: "racehorse").update_all(type: "Horses::Horse::Racehorse")
    Horses::Horse.where(age: 2.., status: "broodmare").update_all(type: "Horses::Horse::Broodmare")
    Horses::Horse.where(age: 2.., status: "stud").update_all(type: "Horses::Horse::Stud")
    Horses::Horse.where(age: ...2).update_all(type: "Horses::Horse::Foal")
    Horses::Horse.where(age: 2..).where(id: Horses::Horse.select(:dam_id)).update_all(type: "Horses::Horse::Broodmare")
    Horses::Horse.where(age: 2..).where(id: Horses::Horse.select(:sire_id)).update_all(type: "Horses::Horse::Stud")
    Horses::Horse.where(age: 2..).where(type: "Horses::Horse::Foal").update_all(type: "Horses::Horse::Racehorse")
    Horses::Horse.update_all(state: "active")
    Horses::Horse.where(status: "deceased").update_all(state: "deceased")
    Horses::Horse.where(status: %w[retired retired_broodmare retired_stud]).update_all(state: "retired")
    Horses::Horse.where("date_of_birth > ?", Date.current).update_all(state: "unborn")
    # rubocop:enable Rails/SkipsModelValidations
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

