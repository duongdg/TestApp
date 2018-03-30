class User < ApplicationRecord
  attr_accessor :remember_token
  before_save {self.email = email.downcase}
  validates :name, presence: true, length: {maximum: Settings.name.maximum_value}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Settings.email.maximum_value},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness:{case_sensitive: false}
  has_secure_password
  validates :password, presence: true,
    length: {minimum: Settings.password.minximum_value}, allow_nil: true

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def current_user? user
    user == current_user
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end

end
