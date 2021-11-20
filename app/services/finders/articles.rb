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
      return if query.blank?

      if same_search?(query)
        previous_search.update(query: query)
      else
        complete_previous_search
        @previous_search = user.searches.create(query: query)
      end
    end

    def previous_search
      @previous_search ||= user.searches.order(:created_at).incomplete.last
    end

    private

    def complete_previous_search
      return if previous_search.blank?

      previous_search.complete!
    end

    def same_search?(query)
      return false if previous_search.blank?

      same_query?(previous_search.query, query) ||
        previous_search.updated_since?(5.seconds.ago)
    end

    def same_query?(previous_query, query)
      previous_query = remove_non_word_chars(previous_query)
      query = remove_non_word_chars(query)
      previous_query.starts_with?(query) || query.starts_with?(previous_query)
    end

    def remove_non_word_chars(query)
      query.gsub(/\W/, '')
    end
  end
end
