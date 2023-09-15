# frozen_string_literal: true

class User < ApplicationRecord
  NAME_LENGTH_MIN = 1
  NAME_LENGTH_MAX = 30
  PASSWORD_LENGTH_MIN = 6
  EMAIL_LENGTH_MAX = 255
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # regex for email: https://qiita.com/HIROKOBA/items/1358aa2e9652688698ee

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save   :downcase_email
  before_create :create_activation_digest

  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships
  validates :name, presence: true, length: { minimum: NAME_LENGTH_MIN, maximum: NAME_LENGTH_MAX }
  validates :email, presence: true, length: { maximum: EMAIL_LENGTH_MAX },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  has_secure_password
  validates :password, presence: true, length: { minimum: PASSWORD_LENGTH_MIN }, allow_nil: true

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost:)
  end

  def self.new_token
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

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    # .ago(): https://qiita.com/mmmm/items/efda48f1ac0267c95c29
    reset_sent_at < PASSWORD_RESET_EXPIRY_HOURS.hours.ago
  end

  def feed
    # # The ? acts as a placeholder for safely inserting variables into
    # # an SQL query, preventing SQL injection attacks.
    # Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)

    # following_ids = "SELECT followed_id FROM relationships
    #                 WHERE  follower_id = :user_id"
    # # .includes is to handle N+1
    # Micropost.where("user_id IN (#{following_ids})
    #               OR user_id = :user_id", user_id: id)
    #               .includes(:user, image_attachment: :blob)

    # SQL subselect: https://www.dofactory.com/sql/subquery
    part_of_feed = 'relationships.follower_id = :id or microposts.user_id = :id'
    # .distinct(): Delete duplicate items. https://qiita.com/toda-axiaworks/items/ad5a0e2322ac6a2ea0f4
    # .left_outer_joins(): https://qiita.com/kurokawa516/items/5ffcfebed09e0d49bf43
    Micropost.left_outer_joins(user: :followers)
             .where(part_of_feed, { id: }).distinct
             .includes(:user, image_attachment: :blob)
  end

  def follow(other_user)
    following << other_user unless self == other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
