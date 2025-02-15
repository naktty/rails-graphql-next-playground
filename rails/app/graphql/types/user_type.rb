# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :github_login, String, null: false
    field :name, String
    field :avatar, String
    field :posted_photos, [Types::PhotoType]
    field :tagged_photos, [Types::PhotoType]

    def posted_photos
      object.photos
    end

    def tagged_photos
      object.tagged_photos
    end
  end
end
