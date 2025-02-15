module Resolvers
  class Photo < BaseResolver
    description "IDで写真を検索"
    type Types::PhotoType, null: true

    argument :id, ID, "写真のID", required: true

    def resolve(id:)
      ::Photo.find(id)
    end
  end
end
