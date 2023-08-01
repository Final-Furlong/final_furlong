# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

notification :terminal_notifier if /Darwin/.match?(`uname`)

guard :bundler do
  require "guard/bundler"
  require "guard/bundler/verify"
  helper = Guard::Bundler::Verify.new

  files = ["Gemfile"]
  files += Dir["*.gemspec"] if files.any? { |f| helper.uses_gemspec?(f) }

  # Assume files are symlinked from somewhere
  files.each { |file| watch(helper.real_path(file)) }
end

group :spec, halt_on_fail: true do
  # NOTE: The cmd option is now required due to the increasing number of ways
  #       rspec may be run, below are examples of the most common uses.
  #  * bundler: 'bundle exec rspec'
  #  * bundler binstubs: 'bin/rspec'
  #  * spring: 'bin/rspec' (This will use spring if running and you have
  #                          installed the spring binstubs per the docs)
  #  * zeus: 'zeus rspec' (requires the server to be started separately)
  #  * 'just' rspec: 'rspec'

  guard :rspec, cmd: "bin/rspec", all_after_start: true, title: "Final Furlong Tests" do
    require "guard/rspec/dsl"
    dsl = Guard::RSpec::Dsl.new(self)

    # RSpec files
    rspec = dsl.rspec
    watch(rspec.spec_helper) { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    # Ruby files
    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)

    # Rails files
    rails = dsl.rails(view_extensions: %w[erb haml slim])
    dsl.watch_spec_files_for(rails.app_files)
    dsl.watch_spec_files_for(rails.views)

    watch(rails.controllers) do |m|
      [
        rspec.spec.call("routing/#{m[1]}_routing"),
        rspec.spec.call("controllers/#{m[1]}_controller")
      ]
    end

    watch(%r{^app/components/(.+)\.rb$}) { |m| "spec/components/#{m[1]}_spec.rb" }

    # Rails config changes
    watch(rails.spec_helper) { rspec.spec_dir }
    watch(rails.routes) { "#{rspec.spec_dir}/routing" }
    watch(rails.app_controller) { "#{rspec.spec_dir}/controllers" }

    # System specs
    watch(rails.view_dirs) { |m| rspec.spec.call("system/#{m[1]}") }
    watch(rails.layouts) { |m| rspec.spec.call("system/#{m[1]}") }
  end

  guard :rubocop, all_on_start: true, cli: ["--autocorrect"] do
    watch(/.+\.rb$/)
    watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
  end
end

# Guard-HamlLint supports a lot options with default values:
# all_on_start: true        # Check all files at Guard startup. default: true
# haml_dires: ['app/views'] # Check Directories. default: 'app/views' or '.'
# cli: '--fail-fast --no-color' # Additional command line options to haml-lint.
guard :haml_lint, cli: "--fail-fast" do
  watch(/.+\.html.*\.haml$/)
  watch(%r{(?:.+/)?\.haml-lint\.yml$}) { |m| File.dirname(m[0]) }
end

