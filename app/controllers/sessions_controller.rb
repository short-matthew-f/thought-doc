class SessionsController < ApplicationController
  def create
    if session_params[:email].include?('@generalassemb.ly')
      @user = User.find_or_initialize_by(email: session_params[:email])
      @user.update(session_params)

      if @user.valid?
        log_in!(@user)
        redirect_to lessons_path
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    log_out!
    redirect_to root_path
  end

  private

  def session_params
    info = request.env['omniauth.auth'].info
    cred = request.env['omniauth.auth'].credentials

    @session_params ||= {
      name:       info.name,
      email:      info.email,
      image_url:  info.image
    }
  end
end
