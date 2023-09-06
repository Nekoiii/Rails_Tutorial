class User < ApplicationRecord
  NAME_LENGTH_MIN = 1
  NAME_LENGTH_MAX = 30
  PASSWORD_LENGTH_MIN = 6
  EMAIL_LENGTH_MAX = 255
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # regex for email: https://qiita.com/HIROKOBA/items/1358aa2e9652688698ee

  attr_accessor :remember_token
  before_save { email.downcase! }

  has_many :microposts
  validates :name, presence: true, length: { minimum: NAME_LENGTH_MIN, maximum: NAME_LENGTH_MAX }
  validates :email, presence: true, length: { maximum: EMAIL_LENGTH_MAX },
                                    format: { with: VALID_EMAIL_REGEX },
                                    uniqueness: true

  has_secure_password
  validates :password, presence: true, length: { minimum: PASSWORD_LENGTH_MIN }
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  def session_token
    remember_digest || remember
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

end
