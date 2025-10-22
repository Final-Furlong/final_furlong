class CreateOdds < ActiveRecord::Migration[8.0]
  def up
    Legacy::Odd.find_each do |legacy_odd|
      Racing::Odd.find_or_create_by!(display: legacy_odd.Odds, value: legacy_odd.Dec)
    end
  end

  def down
    Racing::Odd.delete_all
  end
end

