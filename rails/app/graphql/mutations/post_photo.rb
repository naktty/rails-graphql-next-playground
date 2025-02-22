# frozen_string_literal: true

module Mutations
  class PostPhoto < BaseMutation
    field :photo, Types::PhotoType, null: true

    argument :name, String, required: true
    argument :description, String, required: false

    def resolve(**args)
      photo_num = 30
      photo_num += 1
      photo_url = "https://example.com/photos/#{photo_num}.jpg"
      photo = Photo.create!(**args.merge(user: User.first, url: photo_url))
      {
        photo: photo
      }
    end
  end
end
