class Account::ConsumerController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    respond_to do |format|
      if current_user.update(user_params) 
        format.html { redirect_to account_consumer_index_path, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: consumer_url }
      else
        format.html { render action: :index  }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = current_user
    respond_to do |format|
      if @user.destroy
        format.html { redirect_to root_path, notice: t('users.destroy.success') }
        format.json { render :json, status: :deleted, location: @user }
      else
        format.html { redirect_to user_root_path, alert: t('users.destroy.error') }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end  
  end

  def disable
    @user = current_user
    respond_to do |format|
      if @user.disable
        format.html { redirect_to user_root_path, notice: t('users.disable.success') }
        format.json { render :json, status: :deleted, location: @user }
      else
        format.html { redirect_to user_root_path, alert: t('users.disable.error') }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end  
  end

  def enable
    @user = current_user
    respond_to do |format|
      if @user.enable
        format.html { redirect_to user_root_path, notice: t('users.enable.success') }
        format.json { render :json, status: :deleted, location: @user }
      else
        format.html { redirect_to user_root_path, alert: t('users.enable.error') }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end  
  end

  private

  def user_params
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    params.require(:user).permit(:name,:email, :password, :password_confirmation, :avatar, :phone_number, :company, :about, :type)
  end
end
