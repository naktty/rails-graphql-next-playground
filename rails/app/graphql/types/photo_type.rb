# frozen_string_literal: true

module Types
  class PhotoType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, "The name of the photo", null: false
    field :category, Types::PhotoCategoryType, "The category of the photo"
    field :url, String, "The URL of the photo", null: false
    field :description, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :posted_by, Types::UserType, "The user who posted the photo", null: false

    def posted_by
      object.user
    end
  end
end
