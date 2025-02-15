module Resolvers
  class AllPhotos < BaseResolver
    description "Find all photos"
    type [Types::PhotoType], null: true

    def resolve
      ::Photo.all
    end
  end
end
