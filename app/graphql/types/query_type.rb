module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    description "The query root of this schema"

    # First describe the field signature:
    field :account, AccountType, "Find an account by username" do
      argument :username, String
    end

    def account(username:)
      Account::User.find_by(username:)
    end
  end
end

