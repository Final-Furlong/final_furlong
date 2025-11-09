RSpec.shared_examples "a page that is accessible" do
  it "is axe clean", :axe do
    visit path_to_visit
    expect(page).to be_axe_clean.excluding "#sidebar-toggle"
  end
end

