module Resolvers
  class TotalUsers < BaseResolver
    type Integer, null: false

    def resolve
      ::User.count
    end
  end
end
