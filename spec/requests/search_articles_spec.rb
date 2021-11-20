# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SearchArticles', type: :request do
  describe 'GET /articles/search' do
    let!(:user) { Fabricate(:user) }
    let!(:previous_search) { Fabricate(:search, user: user) }

    before do
      cookies[:user_id] = user.id
    end

    context 'when the query is same as the previous query' do
      let(:query) { previous_search.query[0..-6] }

      it 'does not create new search' do
        expect do
          get search_articles_path(query: query)
        end.to_not change { Search.of_user(user).count }
      end

      it 'updates the previous search query' do
        expect do
          get search_articles_path(query: query)
        end.to change { previous_search.reload.query }.to(query)
        expect(previous_search).to be_incomplete
      end
    end

    context 'When the query is different than the previous query' do
      let(:query) { 'The power of time' }

      context 'and this search has been updated in the past 5 seconds' do
        let!(:previous_search) do
          Fabricate(:search, user: user,
                             created_at: 4.seconds.ago, updated_at: 4.seconds.ago)
        end

        it 'Records a new search' do
          get search_articles_path(query: query)

          new_search = Search.of_user(user).last
          expect(new_search.query).to eq(query)
        end
      end
      context 'and this search has not been updated for more than 5 seconds' do
        let!(:previous_search) do
          Fabricate(:search, user: user,
                             created_at: 6.seconds.ago, updated_at: 6.seconds.ago)
        end

        it 'Sets the previous search as complete' do
          get search_articles_path(query: query)

          new_search = Search.of_user(user).last
          expect(new_search.query).to eq(query)
          expect(previous_search.reload.complete?).to be true
        end
      end
    end
  end
end
