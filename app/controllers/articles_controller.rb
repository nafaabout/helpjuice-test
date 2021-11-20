# frozen_string_literal: true

class ArticlesController < ApplicationController
  def index; end

  def search
    @articles = if params[:query].present?
                  articles_finder.save_search(params[:query])
                  articles_finder.search(params[:query])
                else
                  []
                end
    render :index
  end

  private

  def articles_finder
    @articles_finder ||= Finders::Articles.new(current_user)
  end
end
