# frozen_string_literal: true

module ApplicationHelper
  def logged_in?
    current_user&.admin?
  end

  def current_page?(controller, action)
    params[:controller] == controller && params[:action] == action
  end
end
