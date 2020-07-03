class SessionsController < ApplicationController
  before_action :log_in_user, only: :create

  def new; end

  def create
    log_in @user
    redirect_back_or root_url
  end

  def destroy
    log_out
    redirect_to root_url
  end

  def log_in_user
    @user = User.find_by(email: params[:session][:email].downcase)
    return if @user&.authenticate(params[:session][:password])

    flash.now[:danger] = t ".invalid"
    render :new
  end
end
