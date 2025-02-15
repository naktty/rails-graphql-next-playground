module Resolvers
  class AllPhotos < BaseResolver
    description "Find all photos with pagination"
    type [Types::PhotoType], null: false

    argument :category, Types::PhotoCategoryType, required: false
    argument :first, Integer, required: false
    argument :start, Integer, required: false

    def resolve(category: nil, first: 25, start: 0)
      photos = ::Photo.all
      photos = photos.where(category: category) if category.present?
      
      photos.offset(start).limit(first)
    end
  end
end
