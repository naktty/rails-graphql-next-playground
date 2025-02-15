# frozen_string_literal: true

module Types
  class PhotoType < Types::BaseObject
    field :id, ID, null: false, description: "写真のID"
    field :name, String, "写真の名前", null: false
    field :category, Types::PhotoCategory, "写真のカテゴリー"
    field :url, String, "写真のURL", null: false
    field :description, String, "写真の説明"
    field :created_at, GraphQL::Types::ISO8601DateTime, "作成日時", null: false
    field :posted_by, Types::UserType, "投稿したユーザー", null: false
    field :tagged_users, [Types::UserType], "タグ付けされたユーザー"

    def posted_by
      object.user
    end

    def tagged_users
      object.tagged_users
    end
  end
end
