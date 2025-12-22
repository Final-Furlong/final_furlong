require_relative "responsive_helpers"
require "capybara/cuprite"

DEFAULT_MAX_WAIT_TIME = ENV["CI"] ? 5 : 3

Capybara.server = :puma, { Silent: true }
Capybara.default_max_wait_time = DEFAULT_MAX_WAIT_TIME
Capybara.asset_host = "http://localhost:3000"
Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
  "screenshot_#{example.description.tr(" ", "-").gsub(%r{^.*/spec/}, "")}"
end
Capybara::Screenshot.prune_strategy = :keep_last_run
Capybara.register_driver(:cuprite) do |app|
  options = {
    headless: ENV.fetch("HEADFULL", false) == false,
    window_size: [1024, 768],
    slowmo: (ENV.fetch("HEADFULL", false) == true) ? 5 : 0,
    js_errors: true,
    browser_name: :chrome,
    timeout: (ENV.fetch("CI", false) == true) ? 20 : 5,
    process_timeout: (ENV.fetch("CI", false) == true) ? 60 : 10
  }
  Capybara::Cuprite::Driver.new(app, options)
end
Capybara.register_driver(:playwright) do |app|
  Capybara::Playwright::Driver.new(app,
    browser_type: ENV["PLAYWRIGHT_BROWSER"]&.to_sym || :chromium,
    headless: (false unless ENV["CI"] || ENV["PLAYWRIGHT_HEADLESS"]))
end
Capybara.javascript_driver = :playwright

Capybara.register_driver :custom_rack_test do |app|
  Capybara::RackTest::Driver.new(app,
    respect_data_method: true,
    follow_redirects: true,
    redirect_limit: 10)
end
Capybara.default_driver = :custom_rack_test

# options.add_argument("--force-device-scale-factor=0.95")
# options.add_argument("--disable-gpu")
RSpec.configure do |config|
  config.around(:each, :mobile, type: :system) do |example|
    resize_window_to_mobile

    example.run

    resize_window_default
  end

  config.around(:each, :tablet, type: :system) do |example|
    resize_window_to_tablet

    example.run

    resize_window_default
  end

  config.around(:each, :widescreen, type: :system) do |example|
    resize_window_to_widescreen

    example.run

    resize_window_default
  end
end

#### Playwright tracing
# --- Start Tracing ---
#     page.driver.with_playwright_page do |playwright_page|
#       playwright_context = playwright_page.context
#       playwright_tracing = playwright_context.tracing # Access the tracing object
#
#       playwright_tracing.start(
#         name: "trace_started_correctly", # Optional name
#         screenshots: true,
#         snapshots: true,
#         sources: true
#       )
#     end # End of block for starting

# --- Stop Tracing and Save;
#  view the saved trace.zip file at https://trace.playwright.dev
# page.driver.with_playwright_page do |playwright_page|
#   playwright_context = playwright_page.context
#   playwright_tracing = playwright_context.tracing # Access the tracing object again
#
#   # Ensure the directory exists or use a full path.
#   trace_path = Rails.root.join("tmp/capybara_traces/trace-final-#{Time.now.to_i}.zip")
#   FileUtils.mkdir_p(File.dirname(trace_path)) # Ensure directory exists
#
#   playwright_tracing.stop(path: trace_path.to_s)
# end # End of block for stopping

