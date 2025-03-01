module Types
  class SubscriptionType < Types::BaseObject
    field :new_user, Types::UserType, subscription_scope: true
  end
end
