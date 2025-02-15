module Resolvers
  class AllUsers < BaseResolver
    description "全てのユーザーを取得"
    type [Types::UserType], null: false

    def resolve
      ::User.all
    end
  end
end
