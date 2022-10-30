require_relative "responsive_helpers"

DEFAULT_MAX_WAIT_TIME = ENV["CI"] ? 5 : 3

Capybara.server = :puma, { Silent: true }
Capybara.default_max_wait_time = DEFAULT_MAX_WAIT_TIME
Capybara.asset_host = "http://localhost:3000"
Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
  "screenshot_#{example.description.tr(' ', '-').gsub(%r{^.*/spec/}, '')}"
end
Capybara::Screenshot.prune_strategy = :keep_last_run
Capybara.register_driver :selenium_chrome_headless do |app|
  # Capybara::Selenium::Driver.load_selenium
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--window-size=1024,768")
  options.add_argument("--force-device-scale-factor=0.95")
  options.add_argument("--headless")
  options.add_argument("--disable-gpu")
  options.add_argument("--disable-site-isolation-trials")
  options.add_argument("--no-sandbox")

  Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: [options])
end

Capybara.javascript_driver = :selenium_chrome_headless

RSpec.configure do |config|
  config.around(:each, mobile: true, type: :system) do |example|
    resize_window_to_mobile

    example.run

    resize_window_default
  end

  config.around(:each, tablet: true, type: :system) do |example|
    resize_window_to_tablet

    example.run

    resize_window_default
  end

  config.around(:each, type: :system, widescreen: true) do |example|
    resize_window_to_widescreen

    example.run

    resize_window_default
  end
end

