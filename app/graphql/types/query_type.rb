module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    description "The query root of this schema"

    field :account, AccountType, "Find an account by username" do
      argument :username, String, required: true
    end

    def account(username:)
      resolver = Account::UsersResolver.new(context, { username: })
      resolver.user
    end
  end
end

