class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: [:edit,
   :update]
  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password_resets.new.guide"
      redirect_to root_url
    else
      flash.now[:danger] = t "password_resets.new.not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".not_null")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      # @user.update_attributes(:reset_digest, nil)
      flash[:success] = t ".reset_done"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    unless @user&.activated? && @user.authenticated?(:reset,
      params[:id])
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t ".expired"
      redirect_to new_pasword_rết_url
    end
  end
end
