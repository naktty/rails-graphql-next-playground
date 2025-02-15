class Photo < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :url, presence: true
  enum category: { selfie: 0, portrait: 1, action: 2, landscape: 3, graphic: 4 }
end
