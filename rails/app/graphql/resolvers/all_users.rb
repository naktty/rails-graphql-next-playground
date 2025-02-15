module Resolvers
  class AllUsers < BaseResolver
    description "Find all users"
    type [Types::UserType], null: false

    def resolve
      ::User.all
    end
  end
end
