RSpec.describe Types::QueryType, type: :graphql do
  it "loads account by username" do
    user = create(:user)
    result = FinalFurlongSchema.execute(username_query, context: { current_user: user }, variables: { username: user.username })

    account = result["data"]["account"]
    expect(account["username"]).to eq(user.username)
    expect(account["id"]).to eq(user.id)
  end

  context "when user is not logged in" do
    it "returns error" do
      user = create(:user)
      expect do
        FinalFurlongSchema.execute(username_query, context: { current_user: nil }, variables: { username: user.username })
      end.to raise_error StandardError, "Authorization failed"
    end
  end

  private

    def username_query
      <<-GRAPHQL
      query($username: String!) {
        account(username: $username) {
          id
          username
        }
      }
      GRAPHQL
    end
end

