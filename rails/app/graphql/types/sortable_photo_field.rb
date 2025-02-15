module Types
  class SortablePhotoField < Types::BaseEnum
    description "Photo sortable field"

    value "name", "Name"
    value "description", "Description"
    value "category", "Category"
    value "created_at", "Created At"
  end
end