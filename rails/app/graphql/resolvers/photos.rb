module Resolvers
  class Photos < BaseResolver
    description "Find all photos"
    type [Types::PhotoType], null: true

    def resolve
      ::Photo.all
    end
  end
end
