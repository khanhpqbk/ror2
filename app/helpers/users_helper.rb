module UsersHelper
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")

  end
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def current_user?(user)
    user == current_user
  end
end
