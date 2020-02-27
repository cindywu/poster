module UsersHelper

  def default_avatar_url
    ActionController::Base.helpers.asset_path "avatar.png"
  end

  def avatar_image_tag(user, size = :medium, opts = {})
    klasses = ""
    klasses += " #{opts[:class]}" if opts[:class]
    case size
      when :micro, :mini, :small, :medium, :large
        avatar_size = "#{size}-avatar"
      when :custom
        avatar_size = ""
      else
        avatar_size = "avatar"
    end
    klasses += " #{avatar_size}" unless opts[:class] && opts[:class].include?("avatar")
    size = :medium if [:custom, :mini, :micro].include?(size)
    if user.has_avatar?
      src = user.avatar_url(size)
    else
      src = default_avatar_url
    end
    if opts[:unveil]
      tag :img, data: { src: src }, alt: user.username,
        class: klasses
    else
      image_tag src, alt: user.username, class: klasses
    end
  end

end
