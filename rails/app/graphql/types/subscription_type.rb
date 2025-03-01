module Types
  class SubscriptionType < Types::BaseObject
    field :new_photo, Types::PhotoType, subscription_scope: true
    field :new_user, Types::UserType, subscription_scope: true
  end
end
