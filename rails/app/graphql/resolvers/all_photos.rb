module Resolvers
  class AllPhotos < BaseResolver
    description "Find all photos with pagination and sorting"
    type [Types::PhotoType], null: false

    argument :category, Types::PhotoCategory, required: false
    argument :first, Integer, required: false
    argument :start, Integer, required: false
    argument :sort, Types::SortDirection, required: false
    argument :sort_by, Types::SortablePhotoField, required: false

    def resolve(category: nil, first: 25, start: 0, sort: "DESCENDING", sort_by: "created_at")
      photos = ::Photo.all
      photos = photos.where(category: category) if category.present?

      # ソート方向の決定
      direction = (sort == "ASCENDING") ? :asc : :desc

      # ソートフィールドのマッピング
      sort_field = case sort_by
                   when "created_at"
                     :created_at
                   when "name"
                     :name
                   when "description"
                     :description
                   when "category"
                     :category
                   else
                     :created_at
                   end

      photos.order(sort_field => direction).offset(start).limit(first)
    end
  end
end
