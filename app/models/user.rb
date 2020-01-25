class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  validates :name, presence: true
  validates :access_token, presence: true
  validates :access_token_secret, presence: true
  validates :access_token, uniqueness: { scope: :access_token_secret }
end
