class User < ApplicationRecord
  has_many :photos, dependent: :destroy
  has_many :photo_tags, dependent: :destroy
  has_many :tagged_photos, through: :photo_tags, source: :photo

  validates :github_login, presence: true, uniqueness: true
end
