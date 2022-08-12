require "rails_helper"

# rubocop:disable RSpec/MultipleExpectations
RSpec.describe String do
  it "converts query to search term array" do
    expect("abc def".to_search_terms_arr).to eq %w[%abc% %def%]
    expect("abC Def".to_search_terms_arr).to eq %w[%abc% %def%]
    expect("abC,Def".to_search_terms_arr).to eq %w[%abc% %def%]
    expect("abC:Def".to_search_terms_arr).to eq %w[%abc% %def%]
    expect("abC;Def".to_search_terms_arr).to eq %w[%abc% %def%]
    expect("abC%;Def".to_search_terms_arr).to eq %w[%abc\%% %def%]
    expect("abC;    Def".to_search_terms_arr).to eq %w[%abc% %def%]

    result = "abC;Def".to_search_terms_arr { |term| term == "abC" }
    expect(result).to eq %w[%def%]
  end

  it "normalizes email" do
    expect("".normalize_email).to eq ""
    expect("user@finalfurlong.org".normalize_email).to eq "user@finalfurlong.org"
    expect(" User@FinalFurlong.org ".normalize_email).to eq "user@finalfurlong.org"
  end

  it "normalizes email!" do
    email = " user@finalfurlong.org "
    email.normalize_email!
    expect(email).to eq "user@finalfurlong.org"

    email = ""
    email.normalize_email!
    expect(email).to eq ""
  end

  it "masks input" do
    expect("gerard.kelly@finalfurlong.org".mask_email).to eq "************@************.org"
    expect("test@finalfurlong.org".mask_email).to eq "****@************.org"
    expect("example@gmail.com".mask_email).to eq "*******@*****.com"
  end
end
# rubocop:enable RSpec/MultipleExpectations

