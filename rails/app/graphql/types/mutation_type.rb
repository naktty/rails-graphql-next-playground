# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :add_fake_users, mutation: Mutations::AddFakeUsers
    field :github_auth, mutation: Mutations::GithubAuth
    field :post_photo, mutation: Mutations::PostPhoto
  end
end
