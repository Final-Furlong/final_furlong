class LegacyHorseColor < LegacyRecord
  self.table_name = "ff_horse_colors"
  self.primary_key = "ID"

  def color
    send("Color")
  end
end
