class User < ActiveRecord::Base
	has_many :micropost
	validates :name, presence: true
	validates :email, presence: true

	has_secure_password
	validates :password, length: {minimum: 6}
end
