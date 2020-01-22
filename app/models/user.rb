class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :name, presence: true
  validates :access_token, presence: true
  validates :access_token_secret, presence: true
end
