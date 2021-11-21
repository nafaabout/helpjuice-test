# frozen_string_literal: true

class SessionsController < ApplicationController
  layout false
  skip_before_action :set_user

  def new
    @user = User.new
  end

  def login
    user = User.find_by(username: user_params[:username], password: user_params[:password])

    if user.present?
      cookies[:prev_user_id] = cookies[:user_id]
      cookies[:user_id] = user.id
      @current_user = user
      redirect_to root_path
    else
      flash[:alert] = 'Wrong username or password'

      render :new
    end
  end

  def logout
    cookies[:user_id] = (cookies[:prev_user_id] if prev_user&.guest?)

    redirect_to root_path
  end

  private

  def prev_user
    @prev_user ||= cookies[:prev_user_id] && User.find_by(id: cookies[:prev_user_id])
  end

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
