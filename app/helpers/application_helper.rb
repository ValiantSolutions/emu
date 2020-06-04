# frozen_string_literal: true

module ApplicationHelper
  QR_CHAR_SIZE_VS_SIZE = [7, 14, 24, 34, 44, 58, 64, 84, 98, 119, 137, 155, 177, 194].freeze

  def inline_errors(model, model_attribute)
    result = ''
    if model.errors[model_attribute].any?
      model.errors[model_attribute].each do |message|
        result += "<label class=\"d-block mg-t-3 mg-l-4 mg-b-1\">#{message}</label>"
      end
    end
    result.html_safe
  end

  def flash_class(level)
    case level.to_sym
    when :notice then 'alert-info'
    when :success then 'alert-success'
    when :error then 'alert-danger'
    when :alert then 'alert-danger'
    when :warning then 'alert-warning'
    end
  end

  def flash_prefix(level)
    case level.to_sym
    when :notice then 'Great!'
    when :success then 'Success!'
    when :error then 'Error!'
    when :alert then 'Hmm...'
    when :warning then 'Warning!'
    end
  end

  def minimum_qr_size_from_string(string)
    QR_CHAR_SIZE_VS_SIZE.each_with_index do |size, index|
      return (index + 1) if string.size < size
    end

    # If it's particularly big, we'll try and create codes until it accepts
    i = QR_CHAR_SIZE_VS_SIZE.size
    begin
      i += 1
      RQRCode::QRCode.new(string, size: i)
      return i
    rescue
      retry
    end
  end

  def generate_qrcode(email, secret)
    issuer = h request.domain.to_s

    s = "otpauth://totp/#{issuer}:#{email}?secret=#{secret}&issuer=#{issuer}"
    qrcode = RQRCode::QRCode.new(s, size: minimum_qr_size_from_string(s), level: :l)
    qrcode.as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 4,
      standalone: true
    )
  end

  def avatar_url(user, size)
    if user.avatar_url.nil?
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      "https://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
    else
      user.avatar_url
    end
  end

  def generate_plugin_nav
    emu_plugins = []
    instances = ::Rails::Engine.subclasses.map(&:instance)
    instances.each do |i|

      if i.class.respond_to?(:emu_plugin) && i.class.emu_plugin = true
        if i.class.respond_to?(:nav_menu_item) && !i.class.nav_menu_item.nil? && i.class.respond_to?(:mount_point) && !i.class.mount_point.nil?
          emu_plugins.push({ nav_menu_item: i.class.nav_menu_item, path: i.class.mount_point, as: i })
        end
      end

    end
    #puts emu_plugins.inspect
    emu_plugins
  end

  def highlight_engine_nav(path, mount_point)
    return "active" if path.include?(mount_point)
    return false
  end
end
