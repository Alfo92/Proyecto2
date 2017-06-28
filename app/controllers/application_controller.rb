class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  before_filter :set_cookie_header, :define_language
  skip_before_action :verify_authenticity_token
  before_filter :configure_permitted_parameters, if: :devise_controller?


  protected

  # From: http://stackoverflow.com/questions/2385799/how-to-redirect-to-a-404-in-rails
  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def configure_permitted_parameters
    parameters = [:email, :current_password, :password, :name, :phone_number, :password_confirmation, :current_password, :avatar, :avatar_cache, :type, :language, :provider, :uid]
    devise_parameter_sanitizer.permit(:sign_up,        keys: parameters)
    devise_parameter_sanitizer.permit(:sign_in, keys: parameters)
    devise_parameter_sanitizer.permit(:account_update, keys: parameters)
  end

  def set_cookie_header
    request.headers["HTTP_COOKIE"] ||= request.headers["HTTP_COIKOE"]
  end

  def define_language

    I18n.locale = get_language
  end

end
