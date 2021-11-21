# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  attr_reader :current_user

  before_action :set_user

  private

  def set_user
    if cookies[:user_id].blank?
      @current_user = User.create(role: :guest)
      cookies[:user_id] = @current_user.id
    else
      @current_user = User.find_by(id: cookies[:user_id])
    end
  end
end
