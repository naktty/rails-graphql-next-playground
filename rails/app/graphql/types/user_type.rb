# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :github_login, String, null: false
    field :name, String
    field :avatar, String
    field :posted_photos, [Types::PhotoType]

    def posted_photos
      object.photos.order(created_at: :desc)
    end
  end
end
