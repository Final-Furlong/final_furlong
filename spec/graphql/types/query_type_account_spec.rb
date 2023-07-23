RSpec.describe Types::QueryType do
  it "loads account by username" do
    user = create(:user)
    result = FinalFurlongSchema.execute(username_query, variables: { username: user.username })

    account = result["data"]["account"]
    expect(account["username"]).to eq(user.username)
    expect(account["id"]).to eq(user.id)
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

