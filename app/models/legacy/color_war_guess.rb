module Legacy
  class ColorWarGuess < Record
    self.table_name = "ff_cw_guesses"
  end
end

# == Schema Information
#
# Table name: ff_cw_guesses
#
#  id         :integer          not null, primary key
#  correct    :boolean          not null
#  guessed_id :integer          not null
#  guesser_id :integer          not null
#  secret_id  :integer          not null
#

