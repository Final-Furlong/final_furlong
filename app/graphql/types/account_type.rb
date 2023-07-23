module Types
  class AccountType < Types::BaseObject
    description "An account in the game"

    field :id, String, null: false
    field :admin, Boolean, null: true
    field :email, String, null: true
    field :stable_name, String, null: true
    field :status, String, null: true
    field :username, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :last_online_at, GraphQL::Types::ISO8601DateTime

    def stable_name
      object.stable.name
    end
  end
end

