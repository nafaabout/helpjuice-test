# frozen_string_literal: true

module Finders
  class Articles
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def search(query)
      ::Article.where('title ilike ?', "#{query}%")
    end

    def save_search(query)
      return if query.blank? || user.admin?

      status = complete_query?(query) ? :complete : :incomplete

      if same_search?(query) || previous_search&.incomplete?
        previous_search.update(query: query, status: status)
      else
        @previous_search = user.searches.create(query: query, status: status)
      end
    end

    def previous_search
      @previous_search ||= user.searches.order(:created_at).last
    end

    private

    def same_search?(query)
      return false if previous_search.blank?

      same_query?(previous_search.query, query)
    end

    def same_query?(previous_query, query)
      previous_query = remove_non_word_chars(previous_query)
      query = remove_non_word_chars(query)
      previous_query.starts_with?(query) || query.starts_with?(previous_query)
    end

    def remove_non_word_chars(query)
      query.gsub(/\W/, '')
    end

    def complete_query?(query)
      query.match?(/[.?!]$/)
    end
  end
end
