module Resolvers
  class User < BaseResolver
    description "GitHubのログイン名でユーザーを検索"
    type Types::UserType, null: true

    argument :github_login, String, "GitHubのログイン名", required: true

    def resolve(github_login:)
      ::User.find_by(github_login:)
    end
  end
end
