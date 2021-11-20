# frozen_string_literal: true

class SearchesController < ApplicationController
  def index
    @searches = Search.complete
  end
end
