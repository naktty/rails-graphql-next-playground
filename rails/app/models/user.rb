class User < ApplicationRecord
  has_many :photos, dependent: :destroy
  validates :github_login, presence: true, uniqueness: true
end
