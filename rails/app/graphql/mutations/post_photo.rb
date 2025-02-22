module Mutations
  class PostPhoto < BaseMutation
    field :photo, Types::PhotoType, null: true

    argument :name, String, required: true
    argument :description, String, required: false
    argument :category, Types::PhotoCategory, required: false, default_value: 'portrait'

    def resolve(**args)
      photo = Photo.create!(**args.merge(user: User.first,url: "pending"))
      photo.update!(url: "https://example.com/photos/#{photo.id}.jpg")
      {
        photo: photo,
      }
    end
  end
end
