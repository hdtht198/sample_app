class SessionsController < ApplicationController
  before_action :load_params, only: :create

  def new; end

  def create
    if @user&.authenticate @session[:password]
      if @user.activated?
        log_in @user
        session[:remember_me] == Settings.n1 ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        flash[:warning] = t "account_not_check_email_activation"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "sessions.notification"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def load_params
    @session = params[:session]
    @user = User.find_by email: @session[:email].downcase
    return if @user

    flash.now[:danger] = t "sessions.notification"
    render :new
  end
end
