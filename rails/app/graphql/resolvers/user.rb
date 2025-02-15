module Resolvers
  class User < BaseResolver
    description "Find a user by github login"
    type Types::UserType, null: true

    argument :github_login, String, required: true

    def resolve(github_login:)
      ::User.find_by(github_login:)
    end
  end
end
