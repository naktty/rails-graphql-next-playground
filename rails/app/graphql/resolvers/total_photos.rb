module Resolvers
  class TotalPhotos < BaseResolver
    description "全ての写真の総数を取得"
    type Integer, null: false

    def resolve
      ::Photo.count
    end
  end
end
