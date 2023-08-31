class User < ApplicationRecord
  NAME_LENGTH_MIN = 1
  NAME_LENGTH_MAX = 30
  PASSWORD_LENGTH_MIN = 6
  EMAIL_LENGTH_MAX = 255
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # regex for email: https://qiita.com/HIROKOBA/items/1358aa2e9652688698ee

  before_save { email.downcase! }

  has_many :microposts
  validates :name, presence: true, length: { minimum: NAME_LENGTH_MIN, maximum: NAME_LENGTH_MAX }
  validates :email, presence: true, length: { maximum: EMAIL_LENGTH_MAX },
                                    format: { with: VALID_EMAIL_REGEX },
                                    uniqueness: true

  has_secure_password
  validates :password, presence: true, length: { minimum: PASSWORD_LENGTH_MIN }
end
