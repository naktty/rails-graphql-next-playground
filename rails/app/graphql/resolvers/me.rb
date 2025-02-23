module Resolvers
  class Me < BaseResolver
    description "ログイン中のユーザーを取得"
    type Types::UserType, null: true

    def resolve
      context[:current_user]
    end
  end
end
