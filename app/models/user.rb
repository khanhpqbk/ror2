class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest

  has_many :microposts, dependent: :destroy
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
  # before: not have "false if ..." line
  # two parameter : metaprogramming, to support remember_token, password_token, activation_token,
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    false if remember_digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)

  end



  def activate
    update_attribute(:activated, true)
    update_attribute(:activate_at, Time.zone.now)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)

  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    Micropost.where("user_id = ?", id)
  end

end
