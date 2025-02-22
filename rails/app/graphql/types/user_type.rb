# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false, description: "ユーザーのID"
    field :github_login, String, null: false, description: "GitHubのログイン名"
    field :name, String, description: "ユーザーの名前"
    field :avatar, String, description: "ユーザーのアバター"
    field :posted_photos, [Types::PhotoType], description: "投稿した写真"
    field :in_photos, [Types::PhotoType], description: "タグ付けされた写真"

    def posted_photos
      Loaders::AssociationLoader.for(User, :photos).load(object)
    end

    def in_photos
      object.in_photos
    end
  end
end
