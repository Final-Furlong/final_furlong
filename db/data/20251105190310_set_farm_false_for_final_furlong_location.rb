class SetFarmFalseForFinalFurlongLocation < ActiveRecord::Migration[8.1]
  def up
    Location.where(name: "Final Furlong").find_each do |location|
      location.update(has_farm: false)
    end
  end

  def down
    Location.where(name: "Final Furlong").find_each do |location|
      location.update(has_farm: true)
    end
  end
end

