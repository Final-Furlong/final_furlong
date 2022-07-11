require "factory_bot_rails"
require "faker"

RSpec.describe FactoryBot do
  it "is valid" do
    expect { described_class.lint }.not_to raise_error
  end
end
