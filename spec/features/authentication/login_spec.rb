RSpec.describe "Login Spec" do
  it "allows login with email" do
    admin = create(:admin)

    page.driver.with_playwright_page do |playwright_page|
      playwright_context = playwright_page.context
      playwright_tracing = playwright_context.tracing # Access the tracing object

      playwright_tracing.start(
        name: "trace_started_correctly", # Optional name
        screenshots: true,
        snapshots: true,
        sources: true
      )
    end # End of block for starting

    visit root_path
    within("#top_nav") do
      click_on t("layouts.nav.login")
    end
    save_and_open_page
    expect(page).to have_current_path new_user_session_path, ignore_query: true
    fill_in "user[login]", with: admin.email
    fill_in "user[password]", with: "abc1A$ab"
    click_on t("devise.sessions.new.sign_in")

    expect(page).to have_text t("devise.sessions.signed_in")
    expect(page).to have_current_path root_path, ignore_query: true
    within(".badge") do
      expect(page).to have_text t("view_components.users.online_badge.online")
    end
    page.driver.with_playwright_page do |playwright_page|
      playwright_context = playwright_page.context
      playwright_tracing = playwright_context.tracing # Access the tracing object again

      # Ensure the directory exists or use a full path.
      trace_path = Rails.root.join("tmp/capybara_traces/trace-final-#{Time.now.to_i}.zip")
      FileUtils.mkdir_p(File.dirname(trace_path)) # Ensure directory exists

      playwright_tracing.stop(path: trace_path.to_s)
    end # End of block for stopping
    expect(page.driver.request.cookies.keys).to include "_final_furlong_session"
  end

  it "allows login with username" do
    user = create(:user)

    visit new_user_session_path
    fill_in "user[login]", with: user.username
    fill_in "user[password]", with: "abc1A$ab"
    click_on t("devise.sessions.new.sign_in")

    expect(page).to have_text t("devise.sessions.signed_in")
    within(".badge") do
      expect(page).to have_text t("view_components.users.online_badge.online")
    end
    expect(page.driver.request.cookies.keys).to include "_final_furlong_session"
  end

  it "supports remember me" do
    user = create(:user)

    visit new_user_session_path
    fill_in "user[login]", with: user.username
    fill_in "user[password]", with: "abc1A$ab"
    check "user_remember_me"
    click_on t("devise.sessions.new.sign_in")
    expect(page).to have_text t("devise.sessions.signed_in")
    expect(page.driver.request.cookies.keys).to include "remember_user_token"
  end

  it "does not log in with empty values" do
    visit new_user_session_path
    click_on t("devise.sessions.new.sign_in")
    expect(page).to have_current_path new_user_session_path, ignore_query: true
  end

  it "does not log in with invalid values" do
    visit new_user_session_path
    fill_in "user[login]", with: SecureRandom.alphanumeric(10)
    fill_in "user[password]", with: SecureRandom.alphanumeric(10)
    click_on t("devise.sessions.new.sign_in")
    expect(page).to have_text t("devise.failure.invalid", authentication_keys: "Login")
    expect(page).to have_current_path new_user_session_path, ignore_query: true
  end

  it_behaves_like "a page that is accessible" do
    let(:path_to_visit) { new_user_session_path }
  end
end

