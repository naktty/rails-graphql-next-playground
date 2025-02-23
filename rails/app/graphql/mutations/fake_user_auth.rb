# frozen_string_literal: true

module Mutations
  class FakeUserAuth < BaseMutation
    field :auth_payload, Types::AuthPayloadType, null: false
    argument :github_login, String, required: true

    def resolve(github_login:)
      user = User.find_by(github_login:)
      raise GraphQL::ExecutionError, "GitHubログイン名 '#{github_login}' のユーザーが見つかりません" if user.nil?

      {
        auth_payload: {
          token: user.github_token,
          user:,
        },
      }
    end
  end
end
