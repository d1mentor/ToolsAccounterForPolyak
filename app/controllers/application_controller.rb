class ApplicationController < ActionController::Base
  before_action :set_locale

  def redirect_to_root
    redirect_to '/'
  end

  def store_location
    # сохраняем запрашиваемый url только если это GET-запрос
    if request.get?
      session[:return_to] = request.fullpath
    end
  end

  def tg_newsletter(text, msg_type)
    users = User.where.not(telegram_id: nil).where(role: "admin", notify: true)
    notify_settings = {
      'new_act' => :notify_new_act,
      'change_state' => :notify_change_state,
      'delete_instrument' => :notify_delete_instrument,
      'change_instrument' => :notify_change_instrument
    }
  
    users.each do |user|
      if notify_settings.has_key?(msg_type) && !user.send(notify_settings[msg_type])
        next
      end
  
      TelegramBotService.send_message(user.telegram_id, text)
    end
  end
  

  def set_locale
    begin
      locale = session[:locale] || extract_locale_from_accept_language_header || I18n.default_locale
      session[:locale] = locale unless session[:locale] == locale
      I18n.locale = locale
    rescue
      I18n.locale = "en"
    end
  end

  def admin_level
    return if current_user.admin?

    redirect_to '/'
  end

  def storekeeper_level
    return if current_user.admin? || current_user.storekeeper?

    redirect_to '/'
  end

  def user_level
    return if current_user.admin? || current_user.storekeeper? || current_user.user?

    redirect_to '/'
  end

  private

  def extract_locale_from_accept_language_header
    accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
    return unless accept_language

    accept_language.scan(/^[a-z]{2}/).first
  end
end
