module Resolvers
  class Photo < BaseResolver
    description "Find a photo by ID"
    type Types::PhotoType, null: true

    argument :id, ID, required: true

    def resolve(id:)
      ::Photo.find(id)
    end
  end
end
