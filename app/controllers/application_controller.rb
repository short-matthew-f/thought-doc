class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  before_filter :set_tracking_cookie
  before_filter :keep_user_logged_in

  private

  def current_user
    return nil unless session[:token]

    @current_user ||= User.find_by(token: session[:token])
  end

  def log_in!(user)
    session[:token] = cookies[:token]
    user.update(token: cookies[:token])
  end

  def log_out!
    if current_user
      current_user.update(token: nil)
      session.delete(:token)
      cookies.delete(:token)
    end
  end

  def set_tracking_cookie
    cookies.permanent[:token] = SecureRandom.uuid unless cookies[:token]
  end

  def ensure_current_user
    redirect_to root_url unless current_user
  end

  def keep_user_logged_in
    return if session[:token] || !cookies[:token]

    user = User.find_by(token: cookies[:token])

    log_in!(user) if user
  end
end
