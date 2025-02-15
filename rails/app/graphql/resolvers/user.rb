module Resolvers
  class User < BaseResolver
    description "Find a user by ID"
    type Types::UserType, null: true

    argument :id, ID, required: true

    def resolve(id:)
      ::User.find(id)
    end
  end
end
