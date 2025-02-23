# frozen_string_literal: true

module Mutations
  class AddFakeUsers < BaseMutation
    RANDOM_USER_API_URL = "https://randomuser.me/api"

    field :users, [Types::UserType], null: false

    argument :count, Integer, required: false, default_value: 1

    def resolve(count:)
      results = fetch_random_users(count)
      users = create_users(results)
      { users: users }
    rescue JSON::ParserError => e
      Rails.logger.error "JSON parse error: #{e.message}"
      raise GraphQL::ExecutionError, "APIレスポンスの解析に失敗しました"
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "User creation error: #{e.message}"
      raise GraphQL::ExecutionError, "ユーザーの作成に失敗しました: #{e.message}"
    end

    private

      def fetch_random_users(count)
        uri = URI("#{RANDOM_USER_API_URL}/?results=#{count}")
        response = Net::HTTP.get_response(uri)

        unless response.is_a?(Net::HTTPSuccess)
          Rails.logger.error "RandomUser API Error: #{response.body}"
          raise GraphQL::ExecutionError, "ユーザーデータの取得に失敗しました"
        end

        JSON.parse(response.body)["results"]
      end

      def create_users(results)
        results.map do |result|
          User.create!(
            github_login: result.dig("login", "username"),
            name: "#{result.dig("name", "first")} #{result.dig("name", "last")}",
            avatar: result.dig("picture", "thumbnail"),
            github_token: result.dig("login", "sha1"),
          )
        end
      end
  end
end
