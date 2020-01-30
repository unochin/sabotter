class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :authentications, dependent: :destroy
  has_many :tasks, dependent: :destroy
  accepts_nested_attributes_for :authentications

  validates :name, presence: true
  validates :enc_access_token, presence: true
  validates :enc_access_token_secret, presence: true
  validates :enc_access_token, uniqueness: { scope: :enc_access_token_secret }

end
