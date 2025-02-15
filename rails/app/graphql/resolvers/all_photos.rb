module Resolvers
  class AllPhotos < BaseResolver
    description "ページネーションとソート機能付きで全ての写真を取得"
    type [Types::PhotoType], null: false

    argument :category, Types::PhotoCategory, "フィルタリングするカテゴリー", required: false
    argument :first, Integer, "取得する件数", required: false
    argument :start, Integer, "取得開始位置", required: false
    argument :sort, Types::SortDirection, "ソート方向", required: false
    argument :sort_by, Types::SortablePhotoField, "ソートするフィールド", required: false

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
