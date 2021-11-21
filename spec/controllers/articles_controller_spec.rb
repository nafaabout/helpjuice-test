# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe 'GET search' do
    let!(:user) { Fabricate(:user) }
    let!(:previous_search) { Fabricate(:search, user: user) }
    let(:articles_finder) { Finders::Articles.new(user) }

    before do
      cookies[:user_id] = user.id
      allow(controller).to receive(:articles_finder).and_return(articles_finder)
    end

    context 'when the query is not blank' do
      let(:query) { 'Which os is the best?' }
      let(:articles) { Fabricate.times(2, :article) }

      it 'saves the search query' do
        expect(articles_finder).to receive(:save_search).with(query)
        get :search, params: { query: query }
      end

      it 'searches for articles matching the query' do
        expect(articles_finder).to receive(:search).with(query).and_return(articles)
        get :search, params: { query: query }
      end

      it 'renders the index template' do
        get :search, params: { query: query }
        expect(response).to render_template(:index)
      end
    end
  end
end
