module UsersHelper

  def full_name(user)
    # user.first_name + " " + user.last_name if user.first_name && user.last_name
    user.full_name
  end

  def default_avatar_url
    ActionController::Base.helpers.asset_path("avatar.png", type: :image)
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

  def avatar_cropped_image_tag(user, size = :medium, opts = {})
    klasses = "user-avatar"
    klasses += " #{opts[:classes]}" if opts[:classes]

    if user && user.has_avatar?
      src = user.avatar_url(size)
    else
      src = default_avatar_url
    end

    style = "background: url(#{src}); background-size: cover;background-position: center;"

    "<div class='#{klasses}' style='#{style}'></div>".html_safe
  end

  def time_since_last_comment(user)
    time_ago_in_words(user.comments.last.updated_at) + " ago" unless user.comments.last.blank?
  end

end
