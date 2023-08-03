require "rspec/expectations"

RSpec::Matchers.define :allow_actions do |*actions|
  match do |actual|
    actions.all? { |action| check?(actual, action) == true }
  end

  match_when_negated do |actual|
    actions.none? { |action| check?(actual, action) == true }
  end

  def check?(actual, action)
    actual.apply("#{action}?".to_sym)
  end

  failure_message do |actual|
    failures = actions.select { |action| check?(actual, action) == false }
    "expected that #{actual.class.name} would allow #{expected}, failed on: #{failures}"
  end

  failure_message_when_negated do |actual|
    failures = actions.select { |action| check?(actual, action) == true }
    "expected that #{actual.class.name} would not allow #{expected}, failed on: #{failures}"
  end
end

