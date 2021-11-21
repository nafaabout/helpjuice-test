# frozen_string_literal: true

class SearchesController < ApplicationController
  def index
    authorize Search

    @searches = policy_scope(Search).complete
  end
end
