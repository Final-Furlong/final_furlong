# Ensure a clean commits history
if git.commits.any? { |c| c.message =~ /^Merge branch/ }
  fail('Please rebase to get rid of the merge commits in this PR')
end

has_app_changes = !git.modified_files.grep(/app/).empty?
has_spec_changes = !git.modified_files.grep(/spec/).empty?

# --------------------------------------------------------------------------------------------------------------------
# You've made changes to app, but didn't write any tests?
# --------------------------------------------------------------------------------------------------------------------
warn("There're app changes, but not tests. That's OK as long as you're refactoring existing code.", sticky: false) if has_app_changes && !has_spec_changes

# Don't let testing shortcuts get into master by accident
(git.modified_files + git.added_files - %w(Dangerfile)).each do |file|
  next unless File.file?(file)
  next unless file =~ /^spec.*\.rb/

  contents = File.read(file)
  fail("`xit` or `fit` left in tests (#{file})") if contents.match?(/^\s*[xf]it/)
  fail("`fdescribe` left in tests (#{file})") if contents.match?(/^\s*fdescribe/)
end

# Ensure a clean commits history
if git.commits.any? { |c| c.message =~ /^Merge branch '#{github.branch_for_base}'/ }
  fail('Please rebase to get rid of the merge commits in this PR')
end

# Runs rails_best_practices on modified and added files in the PR
rails_best_practices.lint

# SimpleCov
simplecov.report('coverage/coverage.json', sticky: false)
simplecov.individual_report('coverage/coverage.json', Dir.pwd)

missed_localizable_strings
