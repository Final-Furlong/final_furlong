require "factory_bot_rails"
require "faker"

RSpec.describe FactoryBot do
  it "is valid" do
    pending("need to fix legacy horse breed rankings factory")
    expect { described_class.lint }.not_to raise_error
  end
end

