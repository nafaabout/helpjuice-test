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
    context 'WHEN there is no previous search' do
      before do
        user.searches.destroy_all
      end

      context 'AND the query ends with a punctuation' do
        let(:query) { 'Who is jinkies khan?' }

        it 'creates a new complete search' do
          expect do
            articles_finder.save_search(query)
          end.to change { user.searches.complete.where(query: query).count }.to(1)
        end
      end

      context 'AND the query does not end with a punctuation' do
        let(:query) { 'What is this' }

        it 'creates a new incomplete search' do
          expect do
            articles_finder.save_search(query)
          end.to change { user.searches.incomplete.where(query: query).count }.to(1)
        end
      end
    end

    context 'WHEN there is a previous search' do
      let!(:previous_search) do
        Fabricate(:search, user: user, query: previous_search_query, status: previous_search_status)
      end
      let(:previous_search_status) { :incomplete }

      context 'AND previous query matches the start of the query' do
        let(:query) { 'What are the benefits of cucumber' }
        let(:previous_search_query) { query[0..-5] }

        context 'AND the query is longer' do
          it 'does not create a new search' do
            expect { articles_finder.save_search(query) }.to_not change { user.searches.count }
          end

          it 'updates the previous search query' do
            expect { articles_finder.save_search(query) }.to change { previous_search.reload.query }.to(query)
          end
        end

        context 'AND query is shorter' do
          let(:query) { 'What are the benefits of ' }
          let(:previous_search_query) { "#{query} cucumber" }

          it 'does not create a new search' do
            expect { articles_finder.save_search(query) }.to_not change { user.searches.count }
          end

          it 'updates the previous search query' do
            expect { articles_finder.save_search(query) }.to change { previous_search.reload.query }.to(query)
          end
        end

        context 'AND the query is complete' do
          let(:query) { "#{previous_search.query} cucumber?" }
          let(:previous_search_query) { 'What are the benefits of' }
          let(:previous_search_status) { :incomplete }

          it 'sets the previous_search status as complete' do
            expect { articles_finder.save_search(query) }.to change { previous_search.reload.status }.to('complete')
          end
        end

        context 'AND the query is incomplete' do
          let(:query) { previous_search.query.chop }
          let(:previous_search_query) { 'What are the benefits of cucumber?' }
          let(:previous_search_status) { :complete }

          it 'sets the previous_search status as incomplete' do
            expect { articles_finder.save_search(query) }.to change {
                                                               previous_search.reload.status
                                                             }.to('incomplete')
          end
        end
      end

      context 'AND the previous query does not match the start of the query' do
        context 'AND the previous search is incomplete' do
          let(:query) { 'Why do you use Ruby' }
          let(:previous_search_query) { 'Why Ruby is great' }
          let(:previous_search_status) { :incomplete }

          it 'updates the query of the previous search' do
            expect { articles_finder.save_search(query) }.to change { previous_search.reload.query }.to(query)
          end
        end

        context 'AND the previous search is complete' do
          let(:previous_search_query) { 'Why Ruby is great?' }
          let(:previous_search_status) { :complete }

          context 'AND the query is incomplete' do
            let(:query) { 'Why do you use Ruby' }

            it 'creates a new incomplete search' do
              expect { articles_finder.save_search(query) }.to change { user.searches.incomplete.count }.by(1)
            end

            it 'does not update the previous search' do
              expect { articles_finder.save_search(query) }.to_not change { previous_search.reload.query }
            end
          end

          context 'AND the query is complete' do
            let(:query) { 'Why do you use Ruby?' }

            it 'creates a new complete search' do
              expect { articles_finder.save_search(query) }.to change { user.searches.complete.count }.by(1)
            end

            it 'does not update the previous search' do
              expect { articles_finder.save_search(query) }.to_not change { previous_search.reload.query }
            end
          end
        end
      end
    end
  end
end
