class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user && user&.authenticate(params[:password])
      log_in(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      remember user
      redirect_to :root
    else
      flash.alert = "メールアドレスとパスワードが一致しません"
    end
  end

  def destroy
    log_out
    redirect_to :root
  end
private
  def log_in(user)
    session[:user_id] = user.id
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def user_log_in?
    !current_user.nil?
  end

  def log_out
   session.delete(:user_id)
   @current_user = nil
  end
end