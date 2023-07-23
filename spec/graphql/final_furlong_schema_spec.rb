RSpec.describe FinalFurlongSchema do
  it "has an update-to-date schema" do
    current_definition = described_class.to_definition
    existing_definition = Rails.root.join("app/graphql/schema.graphql").read
    expect(current_definition).to eq(existing_definition), "Update the graphql schema with `bundle exec rails graphql:dump_schema`"
  end
end

