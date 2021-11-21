# frozen_string_literal: true

module ApplicationHelper
  def current_page?(controller, action)
    params[:controller] == controller && params[:action] == action
  end
end
