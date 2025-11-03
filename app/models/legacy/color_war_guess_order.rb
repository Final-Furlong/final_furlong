module Legacy
  class ColorWarGuessOrder < Record
    self.table_name = "ff_cw_guess_order"
  end
end

# == Schema Information
#
# Table name: ff_cw_guess_order
# Database name: legacy
#
#  id         :integer          not null, primary key
#  active     :boolean          not null
#  last_date  :date             not null
#  guesser_id :integer          not null
#

