require "spec_helper"

# rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
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

  it "removes number and symbols" do
    expect("".remove_numbers_and_symbols).to eq ""
    result = "# `@` ? - $ %% && * 23 () [] | _ // Ha-rr  y ; : ~ ! 67 ^^".remove_numbers_and_symbols
    expect(result).to eq "Harry"
  end

  it "removes symbols" do
    expect("".remove_symbols).to eq ""
    result = "# `@` ? - $ %% && * 23 () [] | _ // Ha-rr  y ; : ~ ! 67 ^^".remove_symbols
    expect(result).to eq "23Harry67"
  end

  it "removes extensions" do
    expect("about.html.liquid".remove_extensions).to eq "about"
    expect("about".remove_extensions).to eq "about"
    expect("about.html".remove_extensions).to eq "about"
    expect("about-us.html.liquid".remove_extensions).to eq "about-us"
  end

  it "gets last path component" do
    expect("".last_path_component).to eq ""
    expect("/abc/def/Ghi".last_path_component).to eq "Ghi"
  end

  it "removes trailing slash" do
    expect("".remove_trailing_slash).to eq ""
    expect("  ".remove_trailing_slash).to eq ""
    expect("/d  ".remove_trailing_slash).to eq "/d"
    expect("/d/  ".remove_trailing_slash).to eq "/d"
  end

  it "removes prefix slash" do
    expect("".remove_prefix_slash).to eq ""
    expect("".remove_prefix_slash).to eq ""
    expect("/d  ".remove_prefix_slash).to eq "d  "
    expect("/d/  ".remove_prefix_slash).to eq "d/  "
    expect("//d/a/d  ".remove_prefix_slash).to eq "d/a/d  "
    expect("  //d/a/d  ".remove_prefix_slash).to eq "d/a/d  "
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

  it "converts search string into array of normalized search params" do
    search_params = "aBc   DEF ghi\t  ijk"

    search_terms_array = search_params.into_search_terms

    expect(search_terms_array.length).to eq 4
    expect(search_terms_array[0]).to eq "abc"
    expect(search_terms_array[1]).to eq "def"
    expect(search_terms_array[2]).to eq "ghi"
    expect(search_terms_array[3]).to eq "ijk"

    search_terms_array = "".into_search_terms
    expect(search_terms_array.length).to eq 0

    search_terms_array = "     ".into_search_terms
    expect(search_terms_array.length).to eq 0
  end

  it "removes last path component" do
    expect("a".remove_last_path_component).to eq "a"
    expect("a/".remove_last_path_component).to eq "a"
    expect("a/b".remove_last_path_component).to eq "a"
    expect("a/b/c".remove_last_path_component).to eq "a/b"
  end

  it "normalizes basename and extension" do
    expect(".JS".normalized_basename).to be_nil
    expect("Theme.".normalized_extension).to be_nil

    expect("Theme.JS".normalized_basename).to eq "theme"
    expect("Theme.JS".normalized_extension).to eq "js"
  end

  it "masks input" do
    expect("gerard.kelly@finalfurlong.org".mask_email).to eq "************@************.org"
    expect("test@finalfurlong.org".mask_email).to eq "****@************.org"
    expect("example@gmail.com".mask_email).to eq "*******@*****.com"
  end
end
# rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations
