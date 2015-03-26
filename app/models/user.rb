class User < ActiveRecord::Base
  attr_accessor :remember_token
  has_many :micropost
  validates :name, presence: true
  validates :email, presence: true

  has_secure_password
  # KhanhPQ: allow_blank: true to edit only name/email (not edit pass => pass: blank)
  validates :password, length: {minimum: 6}, allow_blank: true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # KhanhPQ: one of two subtle bugs(other is inside session controller)
  # before: not have the 1st line
  def authenticated?(remember_token)
    false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
