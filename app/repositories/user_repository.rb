class UserRepository < BaseRepository
  root :users

  struct_namespace Accounts
end

