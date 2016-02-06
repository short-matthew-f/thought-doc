class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  before_filter :set_tracking_cookie
  before_filter :keep_user_logged_in

  def index
    redirect_to lessons_path if current_user

    stuff = <<-HERE.strip_heredoc
      1. We could be looking at Ruby:

          ```ruby
          joe_bob = {
            thing: "Something",
            five: [
              1, 2, 3, 4, 5
            ]
          }

          puts joe_bob[:five].sample(2)
          ```

      2. Or JavaScript:

          ```javascript
          var x = function () {
            return 3;
          }

          x(5); // 3
          ```
    HERE

    markdown = Redcarpet::Markdown.new(HTMLwithPygments, fenced_code_blocks: true)

    @stuff_as_html = markdown.render(stuff)
  end

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
