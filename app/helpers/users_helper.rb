# frozen_string_literal: true

module UsersHelper
  def gravatar_for(user, size: 80)
    # gravatar_id  = Digest::MD5.hexdigest(user.email.downcase)
    # gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    # image_tag(gravatar_url, alt: user.name, class: 'gravatar')
    default_avatar_path=asset_path('avatar-1.jpg')
    avatar_url=user.avatar.attached? ? url_for(user.avatar) : default_avatar_path
    image_tag(avatar_url, alt: user.name, class: 'user_avatar')
  end

end
