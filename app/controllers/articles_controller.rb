# frozen_string_literal: true

class ArticlesController < ApplicationController
  def index
    @articles = if params[:query].present?
                  Article.where('title ilike ?', params[:query].concat('%'))
                else
                  []
                end
  end
end
