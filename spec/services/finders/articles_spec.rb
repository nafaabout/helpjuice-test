# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Finders::Articles, type: :service do
  subject(:articles_finder) { described_class.new(user) }
  let!(:user) { Fabricate(:user) }

  describe '#search' do
    let(:query) { matching_articles.first.title[0..5] }
    let!(:matching_articles) { Fabricate.times(2, :article, title: Faker::Book.title) }
    let!(:non_matching_articles) { Fabricate.times(2, :article) }

    it 'returns the articles with title starting with the query' do
      expect(articles_finder.search(query).map(&:id)).to eq(matching_articles.map(&:id))
    end
  end

  describe '#save_search' do
    let(:query) { Faker::Lorem.sentence(word_count: 6) }

    context 'when there is no past search' do
      it 'creates a new incomplete search' do
        expect { articles_finder.save_search(query) }.to change { Search.count }.to(1)
        search = Search.last
        expect(search).to be_incomplete
        expect(search.query).to eq(query)
      end
    end

    context 'When query is longer and previous query matches the start of the query' do
      let!(:previous_search) { Fabricate(:search, user: user, query: query[0..-5], status: :incomplete) }

      it 'does not create a new search' do
        expect { articles_finder.save_search(query) }.to_not change { Search.count }
      end

      it 'updates the previous search query' do
        expect { articles_finder.save_search(query) }.to change { previous_search.reload.query }.to(query)
      end
    end

    context 'When query is shorter and query matches the start of the previous query' do
      let!(:previous_search) { Fabricate(:search, user: user, status: :incomplete) }
      let(:query) { previous_search.query[0..-5] }

      it 'does not create a new search' do
        expect { articles_finder.save_search(query) }.to_not change { Search.count }
      end

      it 'updates the previous search query' do
        expect { articles_finder.save_search(query) }.to change { previous_search.reload.query }.to(query)
      end
    end

    context 'When the previous search query does not match the start of the query' do
      context 'AND previous search have not been updated for more than 5 seconds' do
        let!(:previous_search) do
          Fabricate(:search, user: user, query: 'This is a query',
                             created_at: 6.seconds.ago, updated_at: 6.seconds.ago, status: :incomplete)
        end
        let(:query) { 'And this is another one' }

        it 'sets the previous search as complete' do
          expect { articles_finder.save_search(query) }.to change { previous_search.reload.complete? }.to(true)
        end
      end

      context 'AND the last time since previous search has been updated is less than 5 seconds' do
        let!(:previous_search) do
          Fabricate(:search, user: user, query: 'This is a query',
                             created_at: 4.seconds.ago, updated_at: 4.seconds.ago, status: :incomplete)
        end
        let(:query) { 'And this is another one' }

        it 'does not set the previous search as complete' do
          expect { articles_finder.save_search(query) }.to_not change { previous_search.reload.complete? }
        end
      end
    end
  end
end
