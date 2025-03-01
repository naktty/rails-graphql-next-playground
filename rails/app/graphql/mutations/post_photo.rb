module Mutations
  class PostPhoto < BaseMutation
    field :photo, Types::PhotoType, null: true

    argument :name, String, required: true
    argument :description, String, required: false
    argument :category, Types::PhotoCategory, required: false, default_value: "portrait"

    def resolve(**args)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Only an authorized user can post a photo" if user.nil?

      photo = user.photos.create!(**args, url: "pending")
      photo.update!(url: "/img/photos/#{photo.id}.jpg")

      MySchema.subscriptions.trigger("new_photo", {}, photo, scope: user.id)

      {
        photo:,
      }
    end
  end
end
