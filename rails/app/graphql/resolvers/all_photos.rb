module Resolvers
  class AllPhotos < BaseResolver
    description "Find all photos"
    type [Types::PhotoType], null: false

    argument :category, Types::PhotoCategoryType, required: false

    def resolve(category: nil)
      photos = ::Photo.all
      return photos if category.nil?

      photos.where(category: category)
    end
  end
end
