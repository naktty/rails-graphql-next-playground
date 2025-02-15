module Resolvers
  class TotalPhotos < BaseResolver
    type Integer, null: false

    def resolve
      ::Photo.count
    end
  end
end
  