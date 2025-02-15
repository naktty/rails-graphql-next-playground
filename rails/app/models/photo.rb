class Photo < ApplicationRecord
  belongs_to :user
  has_many :photo_tags, dependent: :destroy
  has_many :tagged_users, through: :photo_tags, source: :user

  validates :name, presence: true
  validates :url, presence: true
  
  enum category: { selfie: 0, portrait: 1, action: 2, landscape: 3, graphic: 4 }
end
