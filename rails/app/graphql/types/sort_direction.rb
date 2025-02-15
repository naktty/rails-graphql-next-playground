module Types
  class SortDirection < Types::BaseEnum
    description "ソート方向"

    value "ASCENDING", "昇順"
    value "DESCENDING", "降順"
  end
end
