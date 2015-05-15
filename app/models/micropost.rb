class Micropost < ActiveRecord::Base
	belongs_to :user

	default_scope -> { order(created_at: :desc) }

	validates :content, length: {maximum: 140}
end
