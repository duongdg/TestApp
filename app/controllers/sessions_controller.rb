class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == Settings.session_ctl_number ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = t "not_active"
        message += t "check_mail"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = t ".login_flash"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
