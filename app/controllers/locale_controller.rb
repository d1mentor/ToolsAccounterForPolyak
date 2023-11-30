class LocaleController < ApplicationController
  def set_locale
    if I18n.available_locales.map(&:to_s).include?(params[:locale])
      session[:locale] = params[:locale]
    end
    redirect_back(fallback_location: "/")
  end
end