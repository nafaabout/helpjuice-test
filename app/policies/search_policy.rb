# frozen_string_literal: true

class SearchPolicy
  attr_reader :user, :search

  def initialize(user, search)
    @user = user
    @search = search
  end

  def index?
    true
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      user.admin? ? scope.all : user.searches
    end

    private

    attr_reader :user, :scope
  end
end
