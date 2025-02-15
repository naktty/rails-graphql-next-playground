module Types
  class SortablePhotoField < Types::BaseEnum
    description "写真のソート可能なフィールド"

    value "name", "名前", value_method: false
    value "description", "説明", value_method: false
    value "category", "カテゴリー"
    value "created_at", "作成日時"
  end
end
