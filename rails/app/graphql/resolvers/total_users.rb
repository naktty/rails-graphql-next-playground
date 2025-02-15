module Resolvers
  class TotalUsers < BaseResolver
    description "全てのユーザーの総数を取得"
    type Integer, null: false

    def resolve
      ::User.count
    end
  end
end
